-- I'm not sure what the exact intention of this function is,
--	but I assumed it's to mark some specific storage key's value
--	as not owned/unusable by the player (by setting its value to -1).
local function releaseStorage(player, storageKey)
	player:setStorageValue(storageKey, -1)
end

-- This function now will run when a player logs out,
--	checks the value of storageKeyToRelease (which is 1000 but ideally would use a global storage key variable),
--	if it's == 1, call releaseStorage on that key after some delay.
function onLogout(player)
	local storageKeyToRelease = 1000 -- assuming the key we want to release on logout is 1000
	local releaseDelay = 1000 -- assuming we want to call releaseStorage 1000ms after the player logs out

	if player:getStorageValue(storageKeyToRelease) == 1 then
		addEvent(releaseStorage, releaseDelay, player, storageKeyToRelease)
	end
	return true
end
