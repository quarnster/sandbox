
local keyboard = libs.keyboard;

--@help End slide show
actions.show_end = function()
	keyboard.stroke("escape");
end

--@help Start slide show
actions.show_start = function()
	keyboard.stroke("control", "4");
end

--@help Zoom in
actions.zoom_in = function()
	keyboard.stroke("oem_plus");
end

--@help Zoom out
actions.zoom_out = function()
	keyboard.stroke("oem_minus");
end

--@help Previous photo
actions.previous = function()
	keyboard.stroke("left");
end

--@help Next photo
actions.next = function()
	keyboard.stroke("next");
end

