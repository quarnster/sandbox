


local utf8 = libs.utf8;
local net = libs.net;
local server = libs.server;
local task = libs.task;
local data = libs.data;
local timer = libs.timer;
local fs = libs.fs;
local state  = 0;
local globtracks = {};
local tim = -1;
local user = "";
local playlist = "";
local timerid;
local playingid;
require "SpotifyAdvancedPlaylist"

events.focus = function(  )
	update();
	--timerid = timer.interval(update, 1000);
end

events.blur = function ( )
	--timer.cancel(timerid);
end

function update()
		print("update");
		local id = os.script("tell application \"Spotify\"", "set a to get id in current track", "end tell");
		if id ~= playingid then 
			playingid = id;
	 		local name = os.script("tell application \"Spotify\"", "set a to get name in current track", "end tell");
			server.update({ id = "currtitle", text = utf8.replace(name, "\n", "")});
	 		local duration = os.script("tell application \"Spotify\"", "set a to get duration in current track", "end tell");

	 		server.update({ id = "currpos", progressMax= duration });

			local imagepath = os.script("tell application \"Spotify\"", 
												"set a to artwork in current track",
											"end tell",
											"tell current application",
												"set temp to (path to temporary items from user domain as text) & \"img.png\"",
												"set fileRef to (open for access temp with write permission)",
													"write a to fileRef",
												"close access fileRef",
												"tell application \"Image Events\"",
													"set theImage to open temp",
													"save theImage as PNG with replacing",
												"end tell",
												"set out to POSIX path of temp",
											"end tell");
			server.update({id = "currimg", image = utf8.replace(imagepath, "\n", "") });
		end
		local volume = os.script("tell application \"Spotify\"",
										"set out to sound volume",
									"end tell");
		server.update({id = "currvol", progress = volume });
		local pos = os.script("tell application \"Spotify\"",
								"set t to player position",
								"set out to round(t)",
							"end tell");
		server.update({id = "currpos", progress = pos });
		local repeating = os.script("tell application \"Spotify\"",
								"set out to repeating",
							"end tell");
		server.update({id = "repeat", checked = utf8.replace(repeating, "\n", "") });
		local shuffling = os.script("tell application \"Spotify\"",
								"set out to shuffling",
							"end tell");
		server.update({id = "suffle", checked = utf8.replace(shuffling, "\n", "") });

		local playing = os.script("tell application \"Spotify\"",
						"set out to player state",
					"end tell");
		if utf8.equals(utf8.replace(playing, "\n", "") , "playing") then
			server.update({id = "play",  icon = "pause"});
		else
			server.update({id = "play",  icon = "play"});
		end
end

actions.poschange = function ( pos )
	os.script("tell application \"Spotify\"",
					"set player position to " .. pos,
				"end tell")
end

actions.volchange = function ( vol )
	os.script("tell application \"Spotify\"",
					"set sound volume to " .. vol,
				"end tell")
end

actions.next = function ()
			 os.script("tell application \"Spotify\"",
						"next track",
					"end tell");
end
actions.previous = function ()
			 os.script("tell application \"Spotify\"",
						"previous track",
					"end tell");
end

actions.repeating = function ( checked )
	if checked then 
		 os.script("tell application \"Spotify\"",
						"set repeating to true",
					"end tell");
	else
		 os.script("tell application \"Spotify\"",
				"set repeating to false",
			"end tell");
	end
end
actions.play = function ()
		 os.script("tell application \"Spotify\"",
						"playpause",
					"end tell");
end
actions.suffle = function ( checked )
	if checked then 
		 os.script("tell application \"Spotify\"",
						"set shuffling to true",
					"end tell");
	else
		 os.script("tell application \"Spotify\"",
				"set shuffling to false",
			"end tell");
	end
end
actions.changeTab = function ( index )
	if index == 0 then

	elseif index == 1 then
		globtracks = updatePlayList(globtracks);
	end
end


actions.back = function()
	print("back");
	if state == 2 then
		globtracks = loadPlaylists(index, user, globtracks);
		state = 1;
	elseif state == 1 then
		globtracks = {};
		globtracks = updatePlayList(globtracks);
		state = 0;
	end
end



actions.listHandler = function( index )
	local us = os.getenv("USER");
	index = index + 1;
	if state == 0 then
		user = globtracks[index].Name;
		globtracks = loadPlaylists(index, user);
		state = 1;
	elseif state == 1 then
		playlist = globtracks[index].Uri;
		print(playlist);
		globtracks = loadTracks(index, playlist);
		state = 2;
	elseif state == 2 then
		print(playlist);
		local a = "play track \"" .. globtracks[index].LongURI .. "\" in context \"" .. playlist .. "\"";
		print(a);
		os.script("tell application \"Spotify\"",
		a,
		"end tell");
	end 
	
end

