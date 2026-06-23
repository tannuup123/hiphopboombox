import 'dart:convert';
import 'dart:io';

import 'package:boombox/modal/category_modal.dart';
import 'package:boombox/modal/comment_modal.dart';
import 'package:boombox/modal/poll_modal.dart';
import 'package:boombox/modal/postmodal.dart';
import 'package:boombox/modal/reply_modal.dart';
import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/modal/sneaker_brand.dart';
import 'package:boombox/modal/user_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyApi{
  static const String baseUrl='https://api.hiphopboombox.com/api';
  static const String imgUrl='https://api.hiphopboombox.com/api/uploads';

  static final _myApi=MyApi();

  static MyApi get getInstance=>_myApi;

  Future<List<PostModal>> getTrending(String filter)async {
    List<PostModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/trending.php'),body: {'filter':filter})
        .then((response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)){
              list.add(PostModal.fromJson(json));
            }

          }
    });
    return list;
  }

  Future<List<PostModal>> getPostByDate(String date)async {
    List<PostModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/postByDate.php'),body: {'date': date})
        .then((response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)){
              list.add(PostModal.fromJson(json));
            }

          }
    });
    return list;
  }

  Future<List<PostModal>> getFeatured()async {
    List<PostModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/featured.php'))
        .then((response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)){
              list.add(PostModal.fromJson(json));
            }

          }
    });
    return list;
  }

  Future<List<CategoryModal>> getCategories()async {
    List<CategoryModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/categories.php'))
        .then((response){
          if(response.statusCode==200){
            // print(response.body);
            for(var json in jsonDecode(response.body)){
              if(json['name'].toString().toLowerCase()=='featured videos'
                  || json['name'].toString().toLowerCase()=='funmesocial') continue;

              list.add(CategoryModal(json['id'], json['name']));
            }

          }
    });
    return list;
  }

  Future<PostModal> getPostById(String postId)async {
    http.Response response= await http.post(Uri.parse('$baseUrl/get/postById.php'),body: {'id': postId});
    if(response.statusCode==200){
      // print(response.body);
      for(var json in jsonDecode(response.body)){
        return PostModal.fromJson(json);
      }
    }
    return throw Exception([response.reasonPhrase]);
  }

  Future<List<CommentModal>> getComments(String postId,int offset)async {
    List<CommentModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/comments.php'),body: {"postId":postId,"offset":offset.toString()})
        .then((response){
          if(response.statusCode==200){
            // print(response.body);
            var data=jsonDecode(response.body);
            for(var json in data['results']){
              list.add(CommentModal.fromJson(json, data['usaTimestamp']));
            }

          }
    });
    return list;
  }

  Future<List<ReplyModal>> getReplies(String commId,int offset)async {
    List<ReplyModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/replies.php'),body: {"commId":commId,"offset":offset.toString()})
        .then((response){
          if(response.statusCode==200){
            // print(response.body);
            var data=jsonDecode(response.body);
            for(var json in data['results']){
              list.add(ReplyModal.fromJson(json, data['usaTimestamp']));
            }

          }
    });
    return list;
  }

  Future<List<CategoryModal>> getVideoTags(String postId)async {
    List<CategoryModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/postTags.php'),body: {"postId":postId}).timeout(const Duration(seconds: 30))
        .then((response){
          if(response.statusCode==200){
            for(var json in jsonDecode(response.body)){
              list.add(CategoryModal(json['id'],json['name']));
            }
          }
    });
    return list;
  }

  Future<List<PostModal>> getVideosByCategory(String postId,String categoryId,int offset)async {
    if(offset!=0){
      offset=offset+1;
    }
    List<PostModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/categories_post.php'),
        body: {"cId": categoryId, "offset":offset.toString(), "filter":"n"})
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        var data=jsonDecode(response.body);
        for(var json in data['results']){
          if(postId==json['id']) continue;

          list.add(PostModal.fromJson(json));
        }

      }
    });
    return list;
  }

  Future<void> updateViews(String postId)async {
    await http.post(Uri.parse('$baseUrl/update/views.php'),body: {"postId":postId})
        .then((response){
      if(response.statusCode==200){}
    });
  }

  Future<List<PostModal>> search(String s)async {
    List<PostModal> list=[];
    await http.post(Uri.parse('$baseUrl/get/search.php'),body: {"s":s})
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        for(var json in jsonDecode(response.body)){
          list.add(PostModal.fromJson(json));
        }

      }
    });
    return list;
  }

  Future<Map<String,dynamic>> login(String email,String password)async {
    Map<String,dynamic> json={};
    await http.post(Uri.parse('$baseUrl/auth/login.php'),body: {"email":email,"password":password})
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        json=jsonDecode(response.body);
      }
    });
    return json;
  }

  Future<bool> register(String email,String password,String name,String image,String ip)async {
    bool isSuccess=false;
    Map<String, dynamic> map={
      "email":email,
      "password":password,
      "name": name,
      "image": image,
      "ip_address": ip};

    await http.post(Uri.parse('$baseUrl/auth/register.php'),headers: {'Content-Type': 'application/json'},
      body: jsonEncode(map),)
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        isSuccess=jsonDecode(response.body)['isSuccess'];
      }
    });
    return isSuccess;
  }

  Future<UserDetails> getUserDetails(String email)async {
    UserDetails userDetails=UserDetails.fromJson({});
    await http.post(Uri.parse('$baseUrl/get/userDetails.php'),body: {"email":email})
        .then((response){
      if(response.statusCode==200){
        List list=jsonDecode(response.body);
        if(list.isNotEmpty) {
          UserDetails.id=list[0]['id'];
          userDetails=UserDetails.fromJson(list[0]);
        }
      }
    });
    return userDetails;
  }

  Future<CommentModal> insertComment(String userId,String postId,String text)async {
    CommentModal commentModal=CommentModal(showReplies: false);
    final Map<String, dynamic> data = {
      "userId": userId,
      "postId": postId,
      "text": text
    };
    await http.post(Uri.parse('$baseUrl/insert/comment.php'),body: jsonEncode(data)).timeout(const Duration(seconds: 30))
        .then((response){
      if(response.statusCode==200){
        print(response.body);
        Map<String,dynamic> map=jsonDecode(response.body);
        if(map['isSuccess']){
          for(var json in map['result']){
            commentModal= CommentModal.fromJson(json, map['usaTimestamp']);
          }
        }
      }
    });
    return commentModal;
  }

  Future<ReplyModal> insertReply(String userId,String commId,String text)async {
    ReplyModal replyModal=ReplyModal.fromJson({}, 0);
    final Map<String, dynamic> data = {
      "userId": userId,
      "commId": commId,
      "text": text
    };
    // print(data);
    await http.post(Uri.parse('$baseUrl/insert/reply.php'),body: jsonEncode(data)).timeout(const Duration(seconds: 30))
        .then((response){
      if(response.statusCode==200){
        // print(response.body);
        Map<String,dynamic> map=jsonDecode(response.body);
        if(map['isSuccess']){
          for(var json in map['result']){
            replyModal= ReplyModal.fromJson(json, map['usaTimestamp']);
          }
        }
      }
    });
    return replyModal;
  }

  Future<String> uploadImage(String filePath) async {
    // Prepare the file
    var file = File(filePath);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/uploadImage.php'),
    );

    // Attach the file to the request
    request.files.add(
      await http.MultipartFile.fromPath('fileToUpload', file.path),
    );

    try {
      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        // You can also read the response body if needed
        var responseBody = await http.Response.fromStream(response);
        print('Response: ${responseBody.body}');
        var json=jsonDecode(responseBody.body);
        if(json['isSuccess']){
          return json['image'];
        }

      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return '';
  }
  
  Future<String> getIp()async {
    String ip='N/A';
    await http.get(Uri.parse('$baseUrl/get/ipAddress.php')).then(
        (response){
          if(response.statusCode==200){
            ip= jsonDecode(response.body)['origin'];
          }
        }
    );
    return ip;
  }

  Future<bool> deleteAccount()async {
    bool isSuccess=false;
    await http.post(Uri.parse('$baseUrl/delete/user.php'),body: {"id":UserDetails.id})
        .then((response){
      if(response.statusCode==200){
        isSuccess= jsonDecode(response.body)['isSuccess'];
      }
    });
    return isSuccess;
  }

  // Future<List<ReplyModal>> getPolls()async {
  //   List<ReplyModal> list=[];
  //   await http.post(Uri.parse('$baseUrl/get/replies.php'),body: {"commId":commId,"offset":offset.toString()})
  //       .then((response){
  //     if(response.statusCode==200){
  //       // print(response.body);
  //       var data=jsonDecode(response.body);
  //       for(var json in data['results']){
  //         list.add(ReplyModal.fromJson(json, data['usaTimestamp']));
  //       }
  //
  //     }
  //   });
  //   return list;
  // }

  Future<List<PollModal>> getPoll()async {
    List<PollModal> list=[];
    http.Response response= await http.get(Uri.parse('$baseUrl/get/latestPoll.php'),);
    if(response.statusCode==200){
      // print(response.body);
      for(var json in jsonDecode(response.body)){
        QuestionModal questionModal=QuestionModal.fromJson(json['question']);
        List<OptionsModal> optionsList=[];
        for(var option in json['options']){
          optionsList.add(OptionsModal.fromJson(option));
        }
        if(!(await checkIfUserSubmittedPoll(questionModal.pollId))) {
          list.add(PollModal(questionModal, optionsList));
        }
      }
    }
    return list;
  }

  Future<void> updateVote(String pollId,String optionId) async {
    await http.post(Uri.parse('$baseUrl/update/votes.php'),body: {"poll_id":pollId,"option_id":optionId})
        .then((response){
      if(response.statusCode==200){

      }
    });
  }

  Future<void> insertUserSubmittedPoll(String pollId) async {
    if(UserDetails.id==null || UserDetails.id=='') return;

    await http.post(Uri.parse('$baseUrl/insert/userSubmittedPoll.php'),body: {"user_id":UserDetails.id,"poll_id":pollId})
        .then((response){
      if(response.statusCode==200){

      }
    });
  }

  Future<bool> checkIfUserSubmittedPoll(String pollId) async {
    bool isSubmitted=false;
    if(UserDetails.id==null || UserDetails.id=='') return isSubmitted;

    await http.post(Uri.parse('$baseUrl/get/userSubmittedPoll.php'),body: {"user_id":UserDetails.id,"poll_id":pollId})
        .then((response){
      if(response.statusCode==200){
        isSubmitted=jsonDecode(response.body)['isSubmitted'];
      }
    });


    return isSubmitted;
  }

  Future<List<ShoeModal>> getRaffle()async {
    List<ShoeModal> list=[];
    http.Response response= await http.post(Uri.parse('$baseUrl/get/raffle.php',),
        body: {"user_id": UserDetails.id??''});
    if(response.statusCode==200){
      // print(response.body);
      var json = jsonDecode(response.body);
      for(var raffle in json['raffles']){
        list.add(ShoeModal.fromJson(raffle,json['primary_size']??'',json['gender']??'',));
      }
    }
    return list;
  }

  Future<Map<String,String>> getRaffleSize(String raffleId)async {
    Map<String,String> map={};
    http.Response response= await http.post(Uri.parse('$baseUrl/get/raffleShoeSizes.php',),
        body: {"raffle_id": raffleId});
    if(response.statusCode==200){
      var json = jsonDecode(response.body);
      for(var size in json){
        map[size['size']]=size['size'];
      }
    }
    return map;
  }

  Future<List<ShoeModal>> getRaffleByCategory(String categoryId, String date, String brand)async {
    List<ShoeModal> list=[];
    http.Response response= await http.post(Uri.parse('$baseUrl/get/raffleByCategory.php'),
    body: {"cat_id": categoryId, "date": date, "brand": brand});
    if(response.statusCode==200){
      // print(response.body);
      for(var json in jsonDecode(response.body)){
        list.add(ShoeModal.fromJson(json,'',''));
      }
    }
    return list;
  }

  Future<List<ShoeModal>> filterSneaker(
      {required String categoryId, String? month, String? year, String? brand})async {
    List<ShoeModal> list=[];
    http.Response response= await http.post(Uri.parse('$baseUrl/get/sneakerFilter.php'),
    body: {"category": categoryId, "month": month??'',"year":year??'', "brand": brand??''});
    if(response.statusCode==200){
      if(response.body.isNotEmpty){
        for(var json in jsonDecode(response.body)){
          list.add(ShoeModal.fromJson(json,'',''));
        }
      }
    }
    return list;
  }


  Future<List<ShoeModal>> getRafflesOrderedByUsers()async {
    List<ShoeModal> list=[];
    http.Response response= await http.post(Uri.parse('$baseUrl/get/raffle_user.php'),
    body: {"user_id": UserDetails.id});
    if(response.statusCode==200){
      // print(response.body);
      for(var json in jsonDecode(response.body)){
        list.add(ShoeModal.fromJson(json,'',''));
      }
    }
    return list;
  }

  Future<void> sendVerifyEmail(
      {required String gender, required String size, required String raffleId})async {
    final prefs= await SharedPreferences.getInstance();
    String email=prefs.getString('email')??'';

    await http.post(Uri.parse('$baseUrl/mail/payment.php'),body: {
      "email":email, "user_id": UserDetails.id,"gender": gender,"size":size, "raffle_id":raffleId })
        .then((response){
      if(response.statusCode==200){

      }
    });
  }

  Future<void> updateUserSize(
      {required String gender, required String size})async {
    if(UserDetails.id==null || UserDetails.id=='') return;

    await http.post(Uri.parse('$baseUrl/update/userSize.php'),body: {
      "user_id":UserDetails.id,"gender": gender,"user_size":size })
        .then((response){
      if(response.statusCode==200){

      }
    });
  }

  Future<void> updateUserDetails(
      {required String name, required String image})async {
    if(UserDetails.id==null || UserDetails.id=='') return;

    await http.post(Uri.parse('$baseUrl/update/avatar.php'),body: {
      "user_id":UserDetails.id,"name": name,"image":image })
        .then((response){
      if(response.statusCode==200){
      }
    });
  }

  Future<List<SneakerBrand>> getSneakersBrands()async {
    List<SneakerBrand> list=[];
    await http.get(Uri.parse('$baseUrl/get/brands.php'),)
        .then((response){
      if(response.statusCode==200){
        list= (jsonDecode(response.body) as List).map((brand)=>SneakerBrand.fromJson(brand)).toList();
      }
    });
    return list;
  }



}