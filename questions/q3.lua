-- As far as I could tell, this function seemed to be doing what it was supposed to already,
--	(except for the potential for direct Player comparison to not work as intended)
--	so I just made some improvements that should increase performance

function do_sth_with_PlayerParty(playerId, membername)
	local player = Player(playerId)
	local party = player:getParty()

	local playerToRemove = Player(membername) -- create the member we want to remove once (instead of every iteration of the below loop)
	local playerToRemoveName = playerToRemove:getName() -- get name of player to remove for use in comparison (could probably also just use `membername`)
	local partyMembers = party:getMembers() -- get party members once (instead of every loop iteration)

	for _, v in pairs(partyMembers) do
		if v:getName() == playerToRemoveName then -- compare between an identifier (could be something other than name) instead of Players directly just in case
			party:removeMember(playerToRemove)
			break -- no reason to keep looping (unless somehow a player could be listed more than once in a party)
		end
	end
end
