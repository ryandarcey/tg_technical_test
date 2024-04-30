function printSmallGuildNames(memberCount)
	-- this method is supposed to print names of all guilds that have less than memberCount max members

	-- Unless this function will be called frequently (meaning its performance matters significantly),
	--	I think the following string concatenation syntax is more readable than string.format,
	--	otherwise, I think having selectGuildQuery = the string.format result makes more sense.
	local selectGuildQuery = "SELECT `name` FROM `guilds` WHERE `max_members` < " .. memberCount .. ";"
	-- local selectGuildQuery = string.format("SELECT `name` FROM `guilds` WHERE `max_members` < %d;", memberCount)

	local resultId = db.storeQuery(selectGuildQuery)
	-- After storing the query, the following loop will print each guild name from result
	--	until there is no next result, then free the query from result.
	-- This seems to be the convention for using the database in otland/forgottenserver based on
	--	https://github.com/otland/forgottenserver/blob/1fcb5c27e62ff767c969d8eb028380f9f5d3325f/data/migrations/8.lua#L9
	if resultId then
		repeat
			print(result.getString(resultId, "name"))
		until not result.next(resultId)
		result.free(resultId)
	end
end
