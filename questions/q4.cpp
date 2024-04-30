// I've given two solutions here, one using smart pointers, and one without

// This first version uses smart pointers, which probably make more sense
//	as long as they're suppported by the C++ version being used,
//	and if this function isn't being called frequently enough that it
//	would make meaningful difference in performance
#include <string>
#include <memory>

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	// make player a unique_ptr so it will automatically be deallocated when it goes out of scope
	std::unique_ptr<Player> player(g_game.getPlayerByName(recipient));
	if (!player) {
		player = new Player(nullptr);
		if (!IOLoginData::loadPlayerByName(player.get() /* .get() to give back a normal pointer for the function */, recipient)) {
			return;
		}
	}

	// Item::CreateItem() could (and hopefully is) implemented in a way that would automatically deallocate
	//	item if it goes out of scope anyway, but assuming negligable performance impact,
	//	also making it a unique pointer doesn't hurt
	std::unique_ptr<Item> item(Item::CreateItem(itemId));
	if (!item) {
		return;
	}

	g_game.internalAddItem(player->getInbox(), item.get() /* add .get() */, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		IOLoginData::savePlayer(player.get() /* add .get() */);
	}
}

// This second version manually frees the allocated storage without smart pointers
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient);
	bool createdPlayer = false; // boolean to track whether we've created a new player (which we would have to free before returning)

	if (!player) {
		player = new Player(nullptr);
		createdPlayer = true;

		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			delete player; // free allocated memory
			return;
		}
	}

	Item* item = Item::CreateItem(itemId); // I'm assuming CreateItem() is implemented such that I won't need to manually free it here
	if (!item) {
		if (createdPlayer) {
			delete player; // free allocated memory
		}
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		// even if we allocated new memory, savePlayer() is taking ownership of it, so no need to free
		IOLoginData::savePlayer(player);
	} else if (createdPlayer) {
		delete player; // free allocated memory
	}
}
