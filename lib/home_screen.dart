import 'package:flutter/material.dart';
import 'notes.dart';
import 'db_handler.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper ? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    loadData ();
  }
  loadData()async{
    notesList = dbHelper!.getNotesList();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes Sql'),
        centerTitle: true,
      ),
      body: Column(
        children: [
         Expanded(
             child:  FutureBuilder(builder: (context,AsyncSnapshot<List<NotesModel>> snapshot){
           if(snapshot.hasData){
    return ListView.builder(
    itemCount: snapshot.data?.length,
    reverse: false,
    shrinkWrap: true,
    itemBuilder: (context,index){
    return Dismissible(
    key: ValueKey<int>(snapshot.data![index].id!),
    direction: DismissDirection.endToStart,
    background: Container(
    color: Colors.red,
    child: Icon(Icons.delete_forever),
    ),
    onDismissed: (DismissDirection direction){
    setState(() {
dbHelper!.delete(snapshot.data![index].id!);
    notesList = dbHelper!.getNotesList();
    snapshot.data!.remove(snapshot.data![index]);
    });
    }
    , child: Card(
    child: ListTile(
    contentPadding: EdgeInsets,all(0),
    title: Text(
    snapshot.data![index].title.toString()
    ),
    subtitle: Text(
    snapshot.data![index].description.toString()
    ),
    trailing: Text(
    snapshot.data![index].age.toString()
    ),
    ),
    );)
    });
    }
    ),
    }else{
    return CircularProgressIndicator();
    }
               ),
         ),
        ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper!.insert(
              NotesModel(
                title:'First Note',
                age:22,
                  description:'Hello this is notes app',
                email:'xxxxx@gmail.com'
              )
          ).then((value){
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
            print('data added');
          }).onError((error,stackTrace){
            print(error.toString());
          });
        },
        child:const Icon(Icons.add),
      ),
    );
  }
}
