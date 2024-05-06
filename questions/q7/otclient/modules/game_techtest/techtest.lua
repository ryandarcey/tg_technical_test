-- something about the button doesn't seem to be working correctly
--	once I tried setting it's position to the bottom right of the window
--	and changing it's position in update() and I couldn't figure out what/why

-- other than resolving that issue I think this would probably be essentially
--	what I'd need to recreate what's shown in the video


-- store some script variables
Techtest = {}

techtestWindow = nil
techtestWindowPosition = nil
techtestWindowSize = nil

button = nil
buttonPosition = nil
buttonSize = nil

function init()
	connect(g_game, { onGameStart = Techtest.create,
						onGameEnd = Techtest.destroy })
end

function terminate()
	disconnect(g_game, { onGameStart = Techtest.create,
							onGameEnd = Techtest.destroy })

	Techtest.destroy()
	Techtest = nil
end

function Techtest.create()
	Techtest.destroy()

	-- initialize script variables
	techtestWindow = g_ui.displayUI('techtest')
	techtestWindowPosition = techtestWindow:getPosition()
	techtestWindowSize = techtestWindow:getSize()

	button = techtestWindow:getChildById('techtestButton')
	buttonPosition = button:getPosition()
	buttonSize = button:getSize()

	-- set button position to bottom right of window
	newPosition = {
		x = (buttonPosition.x + techtestWindowSize.width) - (2 * buttonSize.width),
		y = (buttonPosition.y + techtestWindowSize.height) - (2 * buttonSize.height)
	}
	button:setPosition(newPosition)

	update()
end

-- destroy/reset script variables
function Techtest.destroy()
	if techtestWindow then
		techtestWindow:destroy()
		techtestWindow = nil
		techtestWindowPosition = nil
		techtestWindowSize = nil

		button:destroy()
		button = nil
		buttonPosition = nil
		buttonSize = nil
	end
end

function click()
	setButtonRandomYPosition()
end

function update()
	if techtestWindow == nil or button == nil then
		return
	end

	-- change button's X position by `updateXChange` units every `updateDelay` milliseconds
	updateXChange = -5
	newPosition = {
		x = buttonPosition.x + updateXChange,
		y = buttonPosition.y
	}

	-- TODO: send back to right side of screen and to random Y position
	if newPosition.x < techtestWindowPosition.x then
		newPosition.x = techtestWindowPosition.x
	end

	button:setPosition(newPosition)

	-- call update() again after `updateDelay` milliseconds
	updateDelay = 100
	updateLoopEventId = scheduleEvent(update, updateDelay)
end

function setButtonRandomYPosition()
	-- TODO:
end
