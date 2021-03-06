
local fs = libs.fs;

--@help Copy file or folder
actions.copy = function (a,b)
	fs.copy(a,b);
end

--@help Rename file or folder
actions.rename = function (a,b)
	fs.rename(a,b);
end

--@help Move file or folder
actions.move = function (a,b)
	fs.move(a,b);
end

--@help Delete file or folder
actions.delete = function (path, recursive)
	fs.delete(path, recursive)
end

--@help Write to file
actions.write = function (path, contents)
	fs.write(path, contents);
end

--@help Create folder
actions.createdir = function (path)
	fs.createdir(path);
end

--@help Create all folders
actions.createdirs = function (path)
	fs.createdirs(path);
end

--@help Create file
actions.createfile = function (path)
	fs.createfile(path);
end
