# Recurse

A Brotato mod: reroll the curse factor for already cursed items

When a player has the *Fish Hook* item, all shop items that are locked and already cursed have a chance for the curse to be rerolled.
The curse factor can only increase and all other normal curse functionality is maintained.

### Mod Options
- Recurse Enabled: enable Recurse behavior (default: true)
- Recurse Mode:
  - 1: default reroll: use the normal curse mechanic and replace item when new curse factor is higher than before
  - 2: fixed wave-based: use non-randomized wave-based curse factor, if it is higher than before
  - 3: asymptotic: roll a new curse factor between the current and the maximal possible value (maximum at wave 20: 110%)
  - 4: set curse factor for already cursed items to current maximum curse factor (maximum at wave 20: 110%)
  - 5: random infinite improvement: roll new curse factor between the current value and current + 50%
    - e.g. locked item has 70% curse: new value is rolled between 70% and 120% (can exceed the usually maximum of 110%)
- Recurse Ignore Curse Chance: always recurse locked and already cursed items (default: false)
- Recurse Debug: enable debug messages for Recurse in godot.log (default: true)


### How does Recurse work?

Recurse build on top of the vanilla curse mechanic by allowing already cursed items that are locked in the shop to be recursed.
This means that for these items a new curse factor is rolled and applied, which makes it possible to improve a badly rolled curse factor.
The exact Recurse behavior depends on the Recurse mode and settings.
Recursing also depends on the curse chance, the same way as for the vanilla curse behavior on regular items.
Depending on the selected Recurse mode, the newly rolled curse factor could be lower than before, in which case the new value is discarded and the old curse factor remains.
So, although having a 100% curse chance guarantees a Recurse event for a suitable item, it still might be possible that the curse factor does not increase.
You can enable debug messages in the game log to monitor all Recurse events.

Tip: Choose the *Creature* character to start with one cursed fish hook to more easily recurse any items.


### How does item cursing work (vanilla game mechanic)?

When a player picks up the *Fish Hook* item, they get a new stat called **curse chance**.
When the player leaves the item shop and starts the next wave, there now is a chance that locked items in the shop will become cursed, which improves some of their stats.
How much an item improves depends on the **curse factor** assigned to the item, which by default is also a randomized value.
Only not yet cursed items (i.e. *regular* items) can become cursed and once an item is cursed its stats are fixed, unless the Recurse behavior of this mod is active.

**Curse Chance**:
The curse chance is the sum of all the individual curse chances of the obtained *Fish Hook* items plus a **pity bonus**, which increases if no items were previously cursed. Only at 100% curse chance an item is guaranteed to become cursed.

**Pity Bonus**:
The pity bonus starts at 0% and increases each time you enter the shop if no items were cursed in the previous round. It increases by 25% of the curse chance for every regular locked item (`added pity bonus = curse chance * number of locked regular items / 4`). Note that here the pity bonus is excluded from the curse chance calculation. The pity bonus is reset to 0% as soon as the first item is cursed.

**Curse Factor**:
The curse factor (sometimes called curse strength) is the factor by how much a cursed item has been improved.
It is the sum of a constant 40% base value and two modifier components.
The first modifier is a uniform random value between -30% and +30%.
The second modifier increases with each wave by 2%pt up to wave 21. So, 0% at the first wave up to 40% at wave 21 and higher.
`curse factor = 40% + random modifier (-30% to 30%) + wave bonus (up to 40%)`
This means, on the first wave the possible curse factor values lie between 10% and 70%.
At wave 20 or above the possible value are within 50% and 110%.

**Example**:  
Let's assume the the player is at wave 15 and has obtained the cursed *Fish Hook* (38% curse factor, i.e. 28% curse chance) given by the *Creature* character and an additional regular *Fish Hook* (0% curse factor, i.e. 20% curse chance), which add up to a curse chance of 48%.
The player has locked three out of four items, but the first item is already cursed.
Currently the pity bonus is at 0%. So there is a 48% chance for the second and third item each to get cursed.

In our scenaro the player is unlucky and both items were not cursed this round. This means that the pity bonus increases by 24%pt.
The player is to poor to buy anything and the shop selection stays the same.
As the player starts the next round, the game goes over the locked items in the shop again (now at wave 16).

The curse chance is now at 72% (= 48% + 24%) due to the additional pity bonus.
This time the player is lucky enough and the item gets cursed.
The curse factor is rolled as 80% (= 40% + 10% + 2%*(wave 16 - 1)), based on a random modifier of 10% and the current wave.
Because an item was now successfully cursed, the pity bonus is reset to 0% and the curse chance for the remaining suitable item is now at 48% again.


### Other Mods and Links

Should respect other mods that change the curse behavior, as the original curse_item() function is called after modifying the already cursed locked items.

Pairs well with [Curse Indicator](https://steamcommunity.com/sharedfiles/filedetails/?id=3372276979) to keep track of the cursing progress.
Can be configured with [Mod Options](https://steamcommunity.com/workshop/filedetails/?id=2944608034).

Download from steam workshop: [Recurse](https://steamcommunity.com/sharedfiles/filedetails/?id=3556898502)


### Bug Reports and Suggestions

I will try to fix any bugs that I am made aware of.
Therefore, it would be a big help if you could describe the bug in detail.
If possible, please include the game log written to "%APPDATA%\Brotato\logs\godot.log" for Windows and "~/.local/share/Brotato/logs/godot.log" for Linux-based systems.
You can report bugs by creating an issue on [GitHub](https://github.com/lukasstorck/recurse/issues/new).
This will also create a notification for me that I am less likely to miss :D
