import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class WriteFailure extends Failure {
  WriteFailure();
}

class ReadFailure extends Failure {
  ReadFailure();
}

class UpdateFailure extends Failure {
  UpdateFailure();
}

class DeleteFailure extends Failure {
  DeleteFailure();
}
