{-
xmonad config used by Guilherme Grochau Azzi
Author: Guilherme Grochau Azzi
-}

import qualified Data.Map as Map
import qualified Data.List as List
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicBars
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spiral
import XMonad.Actions.Commands
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import qualified XMonad.Util.EZConfig as EZ
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import System.Exit


------------------------------------------------------------------------
-- | Applications and Utilites

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
systemTerminal :: String
systemTerminal = "gnome-terminal"

-- |Background
-- Path to image used as background
background :: String
background = fehCommand ++ "~/Dropbox/Wallpapers/Third Sunrise.jpg"
  where
    fehCommand = "feh --bg-scale "

-- | NetworkManager Applet
nmapplet :: String
nmapplet = "nm-applet"

-- | Email Client
emailClient :: String
emailClient = "thunderbird"

-- | Power Manager
battery :: String
battery = "gnome-power-manager"

-- | MousePad disable while typing
syndaemon :: String
syndaemon = "syndaemon -K -i 0.5 -m 100"

-- | Setting dual monitors
dualMonitorsCommand :: String
dualMonitorsCommand = "xrandr --output VGA1 --primary --right-of HDMI2 --output HDMI2 --auto"

-- Location of your xmobar.hs / xmobarrc
myXmobarrc = "~/.xmobarrc"


------------------------------------------------------------------------
-- | Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
myManageHook = composeAll []



------------------------------------------------------------------------
-- | Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout = avoidStruts (
    ThreeColMid 1 (3/100) (1/2) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    Full |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)



------------------------------------------------------------------------
-- | Colors and borders
-- Currently based on the ir_black theme.
myNormalBorderColor :: String
myNormalBorderColor     = "#7c7c7c"

myFocusedBorderColor :: String
myFocusedBorderColor    = "#6495ed"

-- | Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth = 1

-- | Color of current window title in xmobar.
xmobarTitleColor :: String
xmobarTitleColor            = "#6495ed"


-- | Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor :: String
xmobarCurrentWorkspaceColor = "#CEFFAC"



------------------------------------------------------------------------
-- | Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask :: KeyMask
myModMask = mod4Mask

myKeys conf = EZ.mkKeymap conf $
  ("M-S-p", runCommand (myCommands conf))
  : [ (k,c) | (_,ks,c) <- myCommandsAndKeys conf, k <- ks ]

myCommands conf = [ (name ++ describeKeys ks, c) | (name,ks,c) <- myCommandsAndKeys conf ]
  where
    describeKeys ks= " (" ++ List.intercalate ", " ks  ++ ")"

--myKeys = let modMask = myModMask in
--myKeys conf@(XConfig {XMonad.modMask = modMask}) = Map.fromList $
myCommandsAndKeys :: XConfig Layout -> [(String, [String], X ())]
myCommandsAndKeys conf =
  ----------------------------------------------------------------------
  -- Custom key bindings

  [ ("Open Terminal", ["C-M-<Return>"],
     spawn systemTerminal)

  , ("Lock Screen", ["C-M-l"],
     spawn "xscreensaver-command --lock")

  , ("Launcher", ["M-p"],
     spawn "$(yeganesh -x -- -fn 'xft:fira sans-12:encoding=utf-8')")

  , ("Web Browser", ["C-M-b"],
     spawn "firefox")

  , ("Screenshot (select area)", ["<Print> a"],
     spawn "scrot \"$HOME/Bilder/%Y-%m-%d_%H:%M:%S.png\" --select")

  , ("Screenshot (current window)", ["<Print> w"],
     spawn "scrot \"$HOME/Bilder/%Y-%m-%d_%H:%M:%S.png\" --focused")

  , ("Screenshot", ["<Print> s"],
     spawn "scrot \"$HOME/Bilder/%Y-%m-%d_%H:%M:%S.png\"")
{-
  -- Mute volume.
  , ((0, 0x1008FF12),
     spawn "pamixer -t")

  -- Decrease volume.
  , ((0, 0x1008FF11),
     spawn "pamixer -d 5")

  -- Increase volume.
  , ((0, 0x1008FF13),
     spawn "pamixer -i 5")

  -- Audio previous.
  , ((0, 0x1008FF16),
     spawn "musickeys Previous")

  -- Play/pause.
  , ((0, 0x1008FF14),
     spawn "musickeys PlayPause")

  --Stop
  , ((0, 0x1008FF15),
     spawn "musickeys Stop")

  -- Audio next.
  , ((0, 0x1008FF17),
     spawn "musickeys Next")

  -- Eject CD tray.
  , ((0, 0x1008FF2C),
     spawn "eject -T")
-}

  ,("Monitor Brightness Up", ["<XF86MonBrightnessUp>"],
    spawn "xbacklight -inc 10")

  ,("Monitor Brightness Down", ["<XF86MonBrightnessDown>"],
    spawn "xbacklight -dec 10")

  -- Suspend to RAM
  --,((0, 0x1008FF2F),
  --  spawn "systemctl suspend")

  -- Toggle WiFi On/Off
--  ,("Toggle WiFi", (0, 0x1008FF95),
--    spawn "eject -T")
  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  , ("Close focused window", ["M-S-c"],
     kill)

  , ("Cycle layout modes", ["M-<Space>"],
     sendMessage NextLayout)

  , ("Set default layout", ["M-S-<Space>"],
     setLayout $ XMonad.layoutHook conf)

  , ("Resize viewed windows to the correct size", ["M-n"],
     refresh)

  , ("Focus next window", ["M-<Tab>", "M-j"],
     windows W.focusDown)

  , ("Focus previous window", ["M-S-<Tab>", "M-k"],
     windows W.focusUp  )

  , ("Focus master window", ["M-m"],
     windows W.focusMaster  )

  , ("Swap window with master", ["M-<Return>"],
     windows W.swapMaster)

  , ("Swap window with next", ["M-S-j"],
     windows W.swapDown)

  , ("Swap window with previous", ["M-S-k"],
     windows W.swapUp)

  , ("Shrink master area", ["M-h"],
     sendMessage Shrink)

  , ("Expand master area", ["M-l"],
     sendMessage Expand)

  , ("Push window back into tiling", ["M-t"],
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ("Increment windows in master area", ["M-,"],
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ("Decrement windows in master area", ["M-."],
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  , ("Log out", ["M-S-q"],
     io exitSuccess)

  , ("Restart xmonad", ["M-q"],
     restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [("Switch to workspace " ++ w, ["M-" ++ show i], windows (W.greedyView w))
      | (i, (w, k)) <- zip [1..] $ zip (XMonad.workspaces conf) [xK_1 .. xK_9]]
  ++
  [("Move window to workspace " ++ show i, ["M-S-" ++ show i], windows (W.shift w))
      | (i, (w, k)) <- zip [1..] $ zip (XMonad.workspaces conf) [xK_1 .. xK_9]]
  ++
  [("Switch to screen " ++ show sc, ["M-" ++ key], screenWorkspace sc >>= flip whenJust (windows . W.view))
      | (key, sc) <- zip ["w", "e", "r"] [0..]]
  ++
  [("Move window to screen " ++ show sc, ["M-S-" ++ key], screenWorkspace sc >>= flip whenJust (windows . W.shift))
      | (key, sc) <- zip ["w", "e", "r"] [0..]]



------------------------------------------------------------------------
-- | Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
--  spawn dualMonitorsCommand
  spawn nmapplet
  spawn emailClient
--  spawn syndaemon
  spawn background
  dynStatusBarStartup myStatusBar myStatusBarCleanup

myStatusBar id = spawnPipe ("xmobar -x" ++ show (fromEnum id) ++ " " ++ myXmobarrc)
myStatusBarCleanup = return () -- TODO



------------------------------------------------------------------------
-- | Run xmonad with all the defaults we set up.
--
main :: IO ()
main = do
  xmonad $ defaults
    { logHook = let pp = xmobarPP
                      { ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
                      , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
                      , ppSep = "   "
                      }
                in multiPP pp (pp {ppTitle = shorten 100})
    , manageHook = manageDocks <+> myManageHook
    , startupHook = setWMName "LG3D" <+> myStartupHook
    , handleEventHook = docksEventHook <+> dynStatusBarEventHook myStatusBar myStatusBarCleanup
    }



------------------------------------------------------------------------
-- | Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in @xmonad/XMonad/Config.hs@
--
-- No need to modify this.
--
defaults = def {
    -- simple stuff
    terminal           = systemTerminal,
--    focusFollowsMouse  = myFocusFollowsMouse,
--    borderWidth        = myBorderWidth,
      modMask            = myModMask
--    workspaces         = myWorkspaces,
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor

    -- key bindings
    , keys               = myKeys
--    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    , layoutHook         = avoidStruts $ smartBorders myLayout
    , manageHook         = manageDocks <+> myManageHook
    , startupHook        = setWMName "LG3D" <+> myStartupHook
}
