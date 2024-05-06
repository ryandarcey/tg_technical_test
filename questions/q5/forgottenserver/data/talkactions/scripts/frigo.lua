-- ADDED FOR TECHNICAL TEST

local playerPosition = nil

-- These effects could be swapped out for the appropriate effects,
--	I just picked one for `smallTornadoEffect` because I couldn't find an
--	actual smaller tornado effect in the version of TFS that I have.

-- Also, CONST_ME_ICETORNADO doesn't seem to be rendering properly for me,
--	but it might be an issue with the version of the client I'm using.
--	for recording the video I swapped it with this water splash instead

local largeTornadoEffect = CONST_ME_WATERSPLASH -- should be CONST_ME_ICETORNADO
local smallTornadoEffect = CONST_ME_STUN -- should be whatever the small tornado effect is

-- these are the coordinates relative to the player that should have a 'large tornado'
local largeTornadoPositions = {
	{x=-1, y=-2}, {x=1, y=-2},
	{x=-3, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=3, y=0},
	{x=-1, y=2}, {x=1, y=2}
}

-- these are the coordinates relative to the player that should have a 'small tornado'
local smallTornadoPositions = {
	{x=0, y=-3},
	{x=-2, y=-1}, {x=0, y=-1}, {x=2, y=-1},
	{x=-2, y=1}, {x=0, y=1}, {x=2, y=1},
	{x=0, y=3}
}

function onSay(player, words, param)
	local message = string.format("%q says\n%q", player:getName(), words)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)

	-- store this in the script rather than constantly passing around `player` and calling getPosition()
	playerPosition = player:getPosition()

	-- 1 second between ice tornado effects
	--	can easily be changed according to effect animation length and desired visual effect
	local largeTornadoDelayInterval = 500
	local largeTornadoNumAnimations = 5

	-- for each position relative to the player that should have a 'large tornado' effect,
	--	send a number of magic effects at that relative position equal to `largeTornadoNumAnimations`
	--	which are each roughly `largeTornadoDelayInterval` milliseconds apart
	for _, relativePosition in pairs(largeTornadoPositions) do
		for i = 0, (largeTornadoNumAnimations - 1) do
			local largeTornadoDelay = i * largeTornadoDelayInterval
			addEvent(makeEffectAtPosition, largeTornadoDelay, largeTornadoEffect, relativePosition)
		end
	end

	-- this is conceptually identical to the above, just with slightly different numbers.
	-- if both effects were definitely going to function this similarly, a separate function could be made,
	-- but with it only happening twice I didn't think that was necessary right now
	local smallTornadoDelayInterval = 500
	local smallTornadoNumAnimations = 6

	for _, relativePosition in pairs(smallTornadoPositions) do
		for i = 0, (smallTornadoNumAnimations - 1) do
			local smallTornadoDelay = i * smallTornadoDelayInterval
			addEvent(makeEffectAtPosition, smallTornadoDelay, smallTornadoEffect, relativePosition)
		end
	end
end

-- separate function to extract out the logic of creating the new position from the loop itself,
--	and then it sends the given magic effect to that position
function makeEffectAtPosition(effect, relativePosition)
	if playerPosition == nil then
		return
	end

	local effectPosition = Position(
		playerPosition.x + relativePosition.x,
		playerPosition.y + relativePosition.y,
		playerPosition.z
	)

	effectPosition:sendMagicEffect(effect)
end
