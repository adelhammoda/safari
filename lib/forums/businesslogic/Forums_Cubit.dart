import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safari/forums/businesslogic/Forums_States.dart';
import 'package:safari/forums/datalayer/Comment_Model.dart';
import 'package:safari/forums/datalayer/Comment_Repository.dart';

class ForumsCubit extends Cubit<ForumsStates>{

  final CommentsRepository commentsRepository;

  List<Comment> Comments=[];

  ForumsCubit(ForumsStates ForumsInitialState, this.commentsRepository) : super(ForumsInitialState);

  List<Comment> GetAllCharacters()
  {
    commentsRepository.GetAllComments(4,"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiY2ZiNWRlY2I0MDhmMTdmOWUyZjFkMWVkMjg0ZWNlZjcyODNjZjY1ZTYwYjc3MWI4ZDE3MmI1OTViNGJmYjgwN2Q4NDE5NzE3NDkxYWNkOTAiLCJpYXQiOjE2NTIwOTUwMTIuMTgzMDQxLCJuYmYiOjE2NTIwOTUwMTIuMTgzMDQ1LCJleHAiOjE2ODM2MzEwMTIuMDExNDAyLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.sUvOx9O5dbPygVf3FlQ4sZMYl9vr_ZWH1LrTGa5ZauWWXxeUHABw-evQ2ZYmVGo-tgo6m6jh-ZcskCcq4n2AAkjBYm5iqn2-05K9a9i_mR0p85L0p_PMae8mHNavwdm93i388TxNvSJn9p4BXUs7E-mnKclDu0mccUhN7tkkNpgZ-wAcwGHyMhpglJaEUJi5J1NPnmXCF9csrwPFa_6aQdJPrHvl87hnalac8MXTGtLUqNIdhuxlITnuKOTbZ_LZ4bkOcn4VWloUC4LynMTB3YLwH3WxX5xkd9MQIQ8DLQv8ZDNMf27E4nm7KCBPUdkoG1CTs-JFshA8kQJEH-0QhreoqkQRoLJ07JWetkPnI91LoPuebQFoHrTHeHF9FJCWhUHO6BuU4tqYIxqok4J4YH2--y7bcdsX-qF9zi2QrfaVo_ZlSnbJxXEIVKICFLmwtszzlpZ6YEjOGbfIaTNITgR4HdrE19lxfupdX3xxym8ODlOGN-sv6LA2r59VpyeKN7fuumdleZ1gDB5kGa0_yAujzM5G5N-pQY-TXtrDvhryfQ6zyNGRiEJV0hFwVOf7CYAUV7g5lHhC5nut-WxUmZQ3XjnyPS0t-xiq9HhUUBfwUuOaTdqmg35J0JT1o__7PA5ijhgJ72XvnwQIKk47bYwHKhyAw8-t2roO3n6F3sY").then((comments) {
      this.Comments=comments.toList();
      print("Cubit");
      print(comments.length);
      emit(CommentsLoaded(Comments));
    });
    return Comments;
  }

  SendQuestion(String Comment){
    emit(ForumsLoadingState());
    this.commentsRepository.AddComment(Comment, "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiY2ZiNWRlY2I0MDhmMTdmOWUyZjFkMWVkMjg0ZWNlZjcyODNjZjY1ZTYwYjc3MWI4ZDE3MmI1OTViNGJmYjgwN2Q4NDE5NzE3NDkxYWNkOTAiLCJpYXQiOjE2NTIwOTUwMTIuMTgzMDQxLCJuYmYiOjE2NTIwOTUwMTIuMTgzMDQ1LCJleHAiOjE2ODM2MzEwMTIuMDExNDAyLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.sUvOx9O5dbPygVf3FlQ4sZMYl9vr_ZWH1LrTGa5ZauWWXxeUHABw-evQ2ZYmVGo-tgo6m6jh-ZcskCcq4n2AAkjBYm5iqn2-05K9a9i_mR0p85L0p_PMae8mHNavwdm93i388TxNvSJn9p4BXUs7E-mnKclDu0mccUhN7tkkNpgZ-wAcwGHyMhpglJaEUJi5J1NPnmXCF9csrwPFa_6aQdJPrHvl87hnalac8MXTGtLUqNIdhuxlITnuKOTbZ_LZ4bkOcn4VWloUC4LynMTB3YLwH3WxX5xkd9MQIQ8DLQv8ZDNMf27E4nm7KCBPUdkoG1CTs-JFshA8kQJEH-0QhreoqkQRoLJ07JWetkPnI91LoPuebQFoHrTHeHF9FJCWhUHO6BuU4tqYIxqok4J4YH2--y7bcdsX-qF9zi2QrfaVo_ZlSnbJxXEIVKICFLmwtszzlpZ6YEjOGbfIaTNITgR4HdrE19lxfupdX3xxym8ODlOGN-sv6LA2r59VpyeKN7fuumdleZ1gDB5kGa0_yAujzM5G5N-pQY-TXtrDvhryfQ6zyNGRiEJV0hFwVOf7CYAUV7g5lHhC5nut-WxUmZQ3XjnyPS0t-xiq9HhUUBfwUuOaTdqmg35J0JT1o__7PA5ijhgJ72XvnwQIKk47bYwHKhyAw8-t2roO3n6F3sY", 4);
    GetAllCharacters();
  }

}