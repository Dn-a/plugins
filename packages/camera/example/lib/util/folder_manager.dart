
import 'dart:io';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class FolderManager {

  final String _globalPath = "/storage/emulated/0/Pictures";
  String _folderAppName;

  FolderManager({String folderAppName = "CustomCamera" }): _folderAppName = folderAppName;

  Future<String> get getPathCustomCamera async => await _customCameraDirectory();

  Future<String> createFolder({String name}) async{
    final customCameraDir = await _customCameraDirectory();
    final path = join(customCameraDir,name);
    String folderNameDirectory = "";

    await Directory(path).create(recursive: true)
        .then((folders) => folderNameDirectory = folders.path)
        .catchError( (error) => print(error));

    return folderNameDirectory;
  }

  Future<String> _customCameraDirectory() async{

    final check = await checkPermission();
    assert(check ? true : throw "WRITE_EXTERNAL_STORAGE denied");

    final externalDirectory = Directory(_globalPath);
    String customCameraDirectory = "";

    await externalDirectory.exists().then((value) async{
      if(value){
        final path = join(externalDirectory.path,_folderAppName);
        await Directory(path).create(recursive: true)
            .then((pictures) => customCameraDirectory = pictures.path)
            .catchError( (error) => print(error));
      }
    }).catchError((error) => print(error));

    return customCameraDirectory;
  }

  Future<bool> checkPermission() async{
    return await Permission.storage.request().isGranted;
  }

}