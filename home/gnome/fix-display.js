#!/usr/bin/env -S gjs -m
/*
 * Bounce the PG27UCDM through a lower refresh rate and back.
 *
 * The PG27UCDM wedges its internal processing when entering 4K@240+DSC
 * (after relogin or suspend) and shows a soft image until a mode-change
 * round trip resets it. Re-applying the same mode is a kernel no-op
 * (drm_mode_equal fast path), so an actual mode change is required.
 */

import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import System from 'system';

const PRODUCT = 'PG27UCDM';
const DWELL_SECONDS = 3;
const METHOD_TEMPORARY = 1;

const proxy = Gio.DBusProxy.new_for_bus_sync(
    Gio.BusType.SESSION,
    Gio.DBusProxyFlags.NONE,
    null,
    'org.gnome.Mutter.DisplayConfig',
    '/org/gnome/Mutter/DisplayConfig',
    'org.gnome.Mutter.DisplayConfig',
    null);

function getState() {
    return proxy
        .call_sync('GetCurrentState', null, Gio.DBusCallFlags.NONE, -1, null)
        .recursiveUnpack();
}

// connector -> current mode id
function currentModes(monitors) {
    const result = new Map();
    for (const [[connector], modes] of monitors) {
        const current = modes.find(mode => mode.at(-1)['is-current']);
        if (current)
            result.set(connector, current[0]);
    }
    return result;
}

// Same resolution, next-highest refresh rate, no VRR.
function alternateMode(modes, currentId) {
    const [, width, height, refresh] = modes.find(m => m[0] === currentId);
    const candidates = modes.filter(m =>
        m[1] === width && m[2] === height &&
        m[3] < refresh - 1 &&
        !m[0].endsWith('+vrr'));
    if (candidates.length === 0)
        return null;
    return candidates.reduce((a, b) => (a[3] > b[3] ? a : b))[0];
}

function buildConfig(logicalMonitors, modes, target, override) {
    return logicalMonitors.map(([x, y, scale, transform, primary, specs]) =>
        [x, y, scale, transform, primary, specs.map(([connector]) => {
            const modeId = connector === target && override
                ? override
                : modes.get(connector);
            const props = modeId.endsWith('+vrr')
                ? {enable_vrr: GLib.Variant.new_boolean(true)}
                : {};
            return [connector, modeId, props];
        })]);
}

function apply(serial, config) {
    proxy.call_sync(
        'ApplyMonitorsConfig',
        new GLib.Variant(
            '(uua(iiduba(ssa{sv}))a{sv})',
            [serial, METHOD_TEMPORARY, config, {}]),
        Gio.DBusCallFlags.NONE,
        -1,
        null);
}

let [serial, monitors, logicalMonitors] = getState();
const modes = currentModes(monitors);
const [[connector], monitorModes] =
    monitors.find(([[, , product]]) => product === PRODUCT) ?? [[]];

if (!connector || !modes.has(connector)) {
    printerr(`${PRODUCT} is not active`);
    System.exit(1);
}

const alternate = alternateMode(monitorModes, modes.get(connector));
if (!alternate) {
    printerr(`no alternate mode for ${PRODUCT} on ${connector}`);
    System.exit(1);
}

apply(serial, buildConfig(logicalMonitors, modes, connector, alternate));
GLib.usleep(DWELL_SECONDS * 1000000);
[serial] = getState();
apply(serial, buildConfig(logicalMonitors, modes, connector, null));
