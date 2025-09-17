import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_b1/model/todo_model.dart';

class TodoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? 'anonymous';

  CollectionReference get _todosCollection =>
      _firestore.collection('users').doc(_userId).collection('todos');

  Stream<List<TodoModel>> getTodos() {
    print("Setting up todos stream for user: $_userId");
    return _todosCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print(
            "Received snapshot with ${snapshot.docs.length} documents",
          ); // Debug
          return snapshot.docs
              .map((doc) => TodoModel.fromFirestore(doc))
              .toList();
        });
  }

  Future<void> addTodo(TodoModel todo) async {
    print("Adding todo to Firestore: ${todo.title}");
    await _todosCollection.add(todo.toFirestore());
    print("Todo added successfully");
  }

  Future<void> updateTodo(TodoModel todo) async {
    await _todosCollection
        .doc(todo.id)
        .update(todo.copyWith(updatedAt: DateTime.now()).toFirestore());
  }

  Future<void> deleteTodo(String todoId) async {
    await _todosCollection.doc(todoId).delete();
  }

  Future<void> toggleTodoStatus(String todoId, bool isDone) async {
    await _todosCollection.doc(todoId).update({
      'isDone': isDone,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<bool> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      print("Signed in anonymously: ${userCredential.user?.uid}");
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Firebase Auth Error: ${e.code} - ${e.message}");
      }
      return false;
    } catch (e) {
      print("Unknown error during anonymous sign-in: $e");
      return false;
    }
  }
}
