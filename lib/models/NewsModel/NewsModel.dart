class NewsModel
{
  List<Article>? articles=[];

  NewsModel.fromJson(Map<String,dynamic>json)
  {
    if(json['articles'] !=null)
      {
        json['articles'].forEach((article)
        {
          articles!.add(Article.fromJson(article));
        });
      }
  }
}

class Article
{
  String? id;
  String? title;
  String? description;
  String? content;
  String? url;
  String? image;
  String? date;
  
  Article.fromJson(Map<String,dynamic>json)
  {
    id=json['id'];
    title=json['title'];
    description=json['description'];
    content=json['content'];
    url=json['url'];
    image=json['image'];
    date=json['date'];
  }
}