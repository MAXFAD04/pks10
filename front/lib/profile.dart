import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/models/books.model.dart';

class ProfilePage extends StatefulWidget {
  // final UserProfile userProfile; // Добавляем поле для UserProfile

  const ProfilePage({super.key}); // Обновляем конструктор

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
  }

  // Переменная состояния для контроля режима редактирования
  bool _isEditing = false;

  void _updateProfile(booksStore) {
    UserProfile profile = UserProfile(
      uid: 1,
      name: _nameController.text,
      surname: _surnameController.text,
      email: _emailController.text
    );
    booksStore.updateProfile(profile);
    _isEditing =
        false; // После обновления профиля выключаем режим редактирования
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль обновлен')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booksStore = Provider.of<BooksStore>(context);
    _nameController.text = booksStore.userProfile.name;
    _surnameController.text = booksStore.userProfile.surname;
    _emailController.text = booksStore.userProfile.email;
    // final userProfile = booksStore.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Имя'),
              enabled:
                  _isEditing, // Делаем поле редактируемым только в режиме редактирования
            ),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Фамилия'),
              enabled:
                  _isEditing, // Делаем поле редактируемым только в режиме редактирования
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled:
                  _isEditing, // Делаем поле редактируемым только в режиме редактирования
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isEditing) {
                  _updateProfile(
                      booksStore); // Если в режиме редактирования, обновляем профиль
                } else {
                  setState(() {
                    _isEditing = true; // Включаем режим редактирования
                  });
                }
              },
              child:
                  Text(_isEditing ? 'Сохранить изменения' : 'Изменить профиль'),
            ),
          ],
        ),
      ),
    );
  }
}
