//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

part of 'persona_bloc.dart';

abstract class PersonaEvent {}

class CreatePersonaEvent extends PersonaEvent {}

class GetListPersonaEvent extends PersonaEvent {}

class ImportPersonaEvent extends PersonaEvent {
  final String words;

  ImportPersonaEvent(this.words);
}

class GetInfoPersonaEvent extends PersonaEvent {
  final String uuid;

  GetInfoPersonaEvent(this.uuid);
}

class NamePersonaEvent extends PersonaEvent {
  final String name;

  NamePersonaEvent(this.name);
}

class PersonaState {
  ActionState createAccountState = ActionState.notRequested;
  ActionState namePersonaState = ActionState.notRequested;

  Persona? persona;
  List<Persona>? personas;

  PersonaState(
      {this.createAccountState = ActionState.notRequested,
      this.namePersonaState = ActionState.notRequested,
      this.persona,
      this.personas});

  PersonaState copyWith({
    ActionState? createAccountState,
    ActionState? namePersonaState,
    Persona? persona,
    List<Persona>? personas,
  }) {
    return PersonaState(
      createAccountState: createAccountState ?? this.createAccountState,
      namePersonaState: namePersonaState ?? this.namePersonaState,
      persona: persona ?? this.persona,
      personas: personas ?? this.personas,
    );
  }
}
