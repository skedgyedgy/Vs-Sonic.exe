package;

import flixel.util.FlxColor;
import haxe.Json;
#if sys
import haxe.Http;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class ArtemisIntegration {
    private static inline var ArtemisAPIUrlDirectoryName:String = "Artemis";
    private static inline var ArtemisAPIUrlFile:String = "./webserver.txt";
    private static inline var ArtemisAPIPluginEndpoints:String = "plugins/endpoints";
    private static inline var THETHINGIMADE:String = "plugins/84c5243c-5492-4965-940c-4ce006524c06/";

    private static var artemisApiUrl:String = "http://localhost:9696/";
    private static var fnfEndpoints:String = "http://localhost:9696/plugins/84c5243c-5492-4965-940c-4ce006524c06/";

    public static inline var DefaultModName:String = "SonicExe"; // if your mod completely replaces vanilla content then change this to your mod name!!!

    public static var artemisAvailable:Bool = false;

    public static function initialize ():Void {
        
        #if sys
        if (true) { // TODO: ClientPrefs.enableArtemis but kade-ified
            trace ("attempting to initialize artemis integration...");
            // get the file that says what the local artemis webserver's url is.
            // the file not being there is a pretty good indication that the user doesn't have artemis so if it isn't there just don't enable this integration
            var path:String = haxe.io.Path.join ([Sys.getEnv ("ProgramData"), ArtemisAPIUrlDirectoryName]);
            if (sys.FileSystem.exists (path) && sys.FileSystem.isDirectory (path)) {
                // is this part stupid? i'm not fluent in haxe so i have no clue if this is stupid or not i'm just rolling with what the api says
                path = haxe.io.Path.join ([path, ArtemisAPIUrlFile]);
                if (sys.FileSystem.exists (path) && !sys.FileSystem.isDirectory (path)) {
                    artemisApiUrl = sys.io.File.getContent (path);

                    // we still need to check to make sure artemis, and its webserver, are actually open
                    // if this request errors out we'll just do nothing for now
                    // TODO: make it retry after a few seconds three or five times??? it might be pointless to do that though
                    trace ("pinging artemis api webserver...");
                    var endpointsRequest = new haxe.Http (artemisApiUrl + ArtemisAPIPluginEndpoints);

                    endpointsRequest.onData = function (data:String) {
                        // do one final check to make sure we didn't just connect to some random ass webserver
                        var r = ~/[\x{200B}-\x{200D}\x{FEFF}]/g;
                        var trimmedData = r.replace (data, ''); // when the web request returns with a zero width space at the start for no fucking reason
                        // trace ("recieved response from what i think/hopefully is the artemis webserver:" + trimmedData);
                        try {
                            var response = haxe.Json.parse (trimmedData);

                            trace ("AHA that's a json response, assuming it's artemis");
                            // TODO: probably should add a check to make sure it's an actual artemis server and not just some random ass webserver that happens to match this criteria

                            fnfEndpoints = artemisApiUrl + THETHINGIMADE;
                            artemisAvailable = true;

                            setBackgroundColor ("#FF000000");
                        } catch (e) {
                            // yep nope if it's not json then it's definitely not what we're looking for
                            // just assume it's a random ass webserver and don't enable integration
                            trace ("nope nevermind, that's not json. probably not an artemis server (" + e + ")");
                        }
                    }

                    endpointsRequest.onError = function (data:String) { trace ("nope nevermind, couldn't connect to server. (recieved error " + data + ")"); }

                    endpointsRequest.request ();
                } else {
                    trace ("nope nevermind, it probably isn't installed (file's not there)");
                }
            } else {
                trace ("nope nevermind, it probably isn't installed (directory's not there)");
            }
        }
        #end
    }

    public static function sendBoyfriendHealth (health:Float) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetHealth");
            request.setPostData (Std.string (health));
            request.request (true);
        }
    }

    public static function setBackgroundFlxColor (color:FlxColor) {
        setBackgroundColor (StringTools.hex (color));
    }

    public static function setBackgroundColor (hexCode:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetBackgroundHex");
            request.setPostData (hexCode);
            request.request (true);
        }
    }

    public static function setAccentColor1 (hexCode:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetAccent1Hex");
            request.setPostData (hexCode);
            request.request (true);
        }
    }

    public static function setAccentColor2 (hexCode:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetAccent2Hex");
            request.setPostData (hexCode);
            request.request (true);
        }
    }
    
    public static function setAccentColor3 (hexCode:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetAccent3Hex");
            request.setPostData (hexCode);
            request.request (true);
        }
    }
    
    public static function setAccentColor4 (hexCode:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetAccent4Hex");
            request.setPostData (hexCode);
            request.request (true);
        }
    }

    public static function setBlammedLights (hexCode:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetBlammedHex");
            request.setPostData (Json.stringify ({ FlashHex: hexCode, FadeTime: 1 }));
            request.request (true);
        }
    }

    public static function triggerFlash (hexCode:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "TriggerFlash");
            request.setPostData (Json.stringify ({ FlashHex: hexCode, FadeTime: 2 }));
            request.request (true);
        }
    }

    public static function setFadeColor (hexCode:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetFadeHex");
            request.setPostData (hexCode);
            request.request (true);
        }
    }

    public static function toggleFade (enable:Bool) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "ToggleFade");
            request.setPostData (Std.string (enable));
            request.request (true);
        }
    }

    public static function setDadHealthColor (dadHex:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetDadHex");
            request.setPostData (dadHex);
            request.request (true);
        }
    }

    public static function setBfHealthColor (bfHex:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetBFHex");
            request.setPostData (bfHex);
            request.request (true);
        }
    }

    public static function setHealthbarFlxColors (dadColor:FlxColor, bfColor:FlxColor) {
        if (artemisAvailable) {
            setDadHealthColor (StringTools.hex (dadColor));
            setBfHealthColor (StringTools.hex (bfColor));
        }
    }

    public static function setBeat (beat:Int) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetBeat");
            request.setPostData (Std.string (beat));
            request.request (true);
        }
    }

    public static function setCombo (combo:Int) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetCombo");
            request.setPostData (Std.string (combo));
            request.request (true);
        }
    }

    public static function breakCombo () {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "BreakCombo");
            request.request (true);
        }
    }

    public static function startSong () {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "StartSong");
            request.request (true);
        }
    }

    public static function setGameState (gameState:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetGameState");
            request.setPostData (gameState);
            request.request (true);
        }
    }

    public static function setModName (modName:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetModName");
            request.setPostData (modName);
            request.request (true);
        }
    }

    public static function resetModName () {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetModName");
            request.setPostData (DefaultModName);
            request.request (true);
        }
    }

    public static function setStageName (stageName:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetStageName");
            request.setPostData (stageName);
            request.request (true);
        }
    }

    public static function setIsPixelStage (isPixelStage:Bool) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetIsPixelStage");
            request.setPostData (Std.string (isPixelStage));
            request.request (true);
        }
    }

    public static function triggerCustomEvent (eventName:String, customArgColor:String, customArgInt:Int) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "TriggerCustomEvent");
            request.setPostData (Json.stringify ({ Name: eventName, Hex: customArgColor, Num: customArgInt }));
            request.request (true);
        }
    }

    public static function sendProfileRelativePath (directory:String) {
        #if sys
        if (artemisAvailable) {
            sendProfileAbsolutePath (sys.FileSystem.absolutePath (directory));
        }
        #end
    }

    public static function sendProfileAbsolutePath (directory:String) {
        if (artemisAvailable) {
            var request = new haxe.Http (fnfEndpoints + "SetProfile");
            request.setPostData (directory);
            request.request (true);
        }
    }

    public static function onError (error:String) {
        trace (error);
    }
}