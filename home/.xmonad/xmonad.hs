import XMonad

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit ( exitWith, ExitCode(ExitSuccess) )

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.EwmhDesktops
import XMonad.Config.Desktop
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers

myTerminal = "xterm"
myLock = "xscreensaver-command -lock"
myDmenu = "exe=`dmenu_run -b` && eval \"exec $exe\""

myWorkspaces = ["α", "β", "γ", "δ", "ε"]

myKeys = [  ((mod4Mask, xK_r), spawn myDmenu)
          , ((mod4Mask, xK_w), spawn "x-www-browser")
          , ((mod4Mask, xK_l), spawn myLock)
          , ((mod4Mask, xK_x), io (exitWith ExitSuccess))
         ] ++
         [((m .|. mod1Mask, k), windows $ f i) --make M-# view, not swap
              | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myManageHook = composeAll $
    [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
    ]

main = do
    xmonad $ ewmh desktopConfig
        { manageHook = manageDocks <+> myManageHook
                        <+> manageHook desktopConfig
        , terminal = myTerminal
        , layoutHook = avoidStruts  $  smartBorders $ layoutHook defaultConfig
        , borderWidth = 3
        , normalBorderColor = "black"
        , focusedBorderColor = "#63B8FF"
        , workspaces = myWorkspaces
        }`additionalKeys` myKeys
