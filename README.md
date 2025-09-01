# Recurse

A Brotato mod: reroll the curse level for already cursed items 

When a player has the "fish hook" item, all shop items that are locked and already cursed have a chance for the curse to be rerolled.
The curse factor can only increase and all other normal curse functionality is maintained.
Should respect other mods that change the curse behavior, as the original curse_item() function is called after modifying the already cursed locked items.

Mod Options:
- Recurse Mode:
  - 0: off: locked, already cursed items are not modified
  - 1: default reroll: use the normal curse mechanic and replace item when new curse factor is higher than before
  - 2: fixed level-based: use non-randomized level-based curse factor, if it is higher than before
  - 3: asymptotic: roll a new curse factor between the current and the maximal possible value (maximum at wave 20: 110%)

Pairs well with [Curse Indicator](https://steamcommunity.com/sharedfiles/filedetails/?id=3372276979) to keep track of the cursing progress.
Can be configured with [ModOptions](https://steamcommunity.com/workshop/filedetails/?id=2944608034).

Download from steam workshop: [Recurse](https://steamcommunity.com/sharedfiles/filedetails/?id=3556898502)
