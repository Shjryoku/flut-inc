/// Object equipable by a [Character].
abstract class Item {
  final String name;
  final int defensive;

  Item(this.name, this.defensive);
}

class Hat extends Item{
  Hat(String name, int defensive) : super(name, defensive);
}

class Torso extends Item{
  Torso(String name, int defensive) : super(name, defensive);
}

class LeftHand extends Item{
  LeftHand(String name, int defensive) : super(name, defensive);
}

class RightHand extends Item{
  RightHand(String name, int defensive) : super(name, defensive);
}

class Legs extends Item{
  Legs(String name, int defensive) : super(name, defensive);
}

class Shoes extends Item{
  Shoes(String name, int defensive) : super(name, defensive);
}

/// Entity equipping [Item]s.
class Character{
  Item? leftHand;
  Item? rightHand;
  Item? hat;
  Item? torso;
  Item? legs;
  Item? shoes;

  /// Returns all the [Item]s equipped by this [Character].
  Iterable<Item> get equipped =>
      [leftHand, rightHand, hat, torso, legs, shoes].whereType<Item>();

  /// Returns the total damage of this [Character].
  int get damage => (5 - equipped.length);

  /// Returns the total defense of this [Character].
  int get defense => equipped.fold(0, (sum, item) => sum + item.defensive);

  /// Equips the provided [item], meaning putting it to the corresponding slot.
  ///
  /// If there's already a slot occupied, then throws a [OverflowException].
  void equip([Item? item, String? slotName]) {
    switch(slotName){
        case 'leftHand':
        if(leftHand != null) throw OverflowException(slotName!);
        leftHand = item;
        break;
        case 'rightHand':
        if(rightHand != null) throw OverflowException(slotName!);
        rightHand = item;
        break;
        case 'hat':
        if(hat != null) throw OverflowException(slotName!);
        hat = item;
        break;
        case 'torso':
        if(torso != null) throw OverflowException(slotName!);
        torso = item;
        break;
        case 'legs':
        if(legs != null) throw OverflowException(slotName!);
        legs = item;
        break;
        case 'shoes':
        if(shoes != null) throw OverflowException(slotName!);
        shoes = item;
        break;
      }
    }
}

/// [Exception] indicating there's no place left in the [Character]'s slot.
class OverflowException implements Exception {
  final String slotName;
  OverflowException(this.slotName);

  @override
  String toString() => 'Slot $slotName is busy';
}

void main() {
  // Implement mixins to differentiate [Item]s into separate categories to be
  // equipped by a [Character]: weapons should have some damage property, while
  // armor should have some defense property.
  //
  // [Character] can equip weapons into hands, helmets onto hat, etc.

  final character = Character();

  character.equip(Hat('Great Hat', 3), 'hat');
  character.equip(Torso('Steel Armor', 8), 'torso');
  character.equip(LeftHand('Sword', 1), 'leftHand');
  character.equip(RightHand('Shield', 5), 'rightHand');

  print('Equipped: ${character.equipped}');
  print('Total defense: ${character.defense}');
  print('Damage: ${character.damage}');

  try {
    character.equip(Hat('Another Hat', 1), 'hat');
  } catch (e) {
    print(e);
  }
}
