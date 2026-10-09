import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/design_system_catalog/sections/unit_sprites/sprite_preview_game.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_direction.dart';

const _speeds = [0.25, 0.5, 1.0, 2.0];

const _directionLabels = {
  UnitDirection.backLeft: '↖',
  UnitDirection.back: '↑',
  UnitDirection.backRight: '↗',
  UnitDirection.frontLeft: '↙',
  UnitDirection.front: '↓',
  UnitDirection.frontRight: '↘',
};

class UnitSpritesSection extends StatefulWidget {
  const UnitSpritesSection({super.key});

  @override
  State<UnitSpritesSection> createState() => _UnitSpritesSectionState();
}

class _UnitSpritesSectionState extends State<UnitSpritesSection> {
  var _speed = 1.0;
  var _animation = PreviewAnimation.idle;
  var _game = SpritePreviewGame(character: allTeamCharacters.first);
  late var _direction = _game.restingDirection;

  void _pickCharacter(Character character) => setState(() {
    _game = SpritePreviewGame(character: character)..changeSpeed(_speed);
    _direction = _game.restingDirection;
    _animation = PreviewAnimation.idle;
  });

  void _face(UnitDirection direction) => setState(() {
    _direction = direction;
    _game.face(direction);
  });

  void _play(PreviewAnimation animation) => setState(() {
    _animation = animation;
    _game.play(animation);
  });

  void _changeSpeed(double speed) => setState(() {
    _speed = speed;
    _game.changeSpeed(speed);
  });

  void _triggerAbility() => setState(() {
    _animation = PreviewAnimation.idle;
    _game.triggerAbility();
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: previewRegion.width / previewRegion.height,
          child: ClipRect(
            child: GameWidget(key: ObjectKey(_game), game: _game),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.space4),
            children: [
              DropdownButton<Character>(
                isExpanded: true,
                value: _game.character,
                onChanged: (character) => character == null ? null : _pickCharacter(character),
                items: [
                  for (final character in [...allTeamCharacters, ...allEnemyCharacters])
                    DropdownMenuItem(value: character, child: Text(character.id.value)),
                ],
              ),
              const CatalogBlockTitle('Direção'),
              _Choices(
                selected: _direction,
                onSelected: _face,
                labels: _directionLabels,
              ),
              const CatalogBlockTitle('Animação'),
              _Choices(
                selected: _animation,
                onSelected: _play,
                labels: {for (final animation in PreviewAnimation.values) animation: animation.label},
              ),
              const CatalogBlockTitle('Velocidade'),
              _Choices(
                selected: _speed,
                onSelected: _changeSpeed,
                labels: {for (final speed in _speeds) speed: '$speed×'},
              ),
              const SizedBox(height: AppSpacing.space4),
              FilledButton(onPressed: _triggerAbility, child: const Text('Disparar habilidade')),
            ],
          ),
        ),
      ],
    );
  }
}

class _Choices<Choice> extends StatelessWidget {
  const _Choices({required this.labels, required this.selected, required this.onSelected});

  final Choice selected;
  final Map<Choice, String> labels;
  final ValueChanged<Choice> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.space2,
      children: [
        for (final MapEntry(key: choice, value: label) in labels.entries)
          ChoiceChip(label: Text(label), selected: choice == selected, onSelected: (isSelected) => onSelected(choice)),
      ],
    );
  }
}
