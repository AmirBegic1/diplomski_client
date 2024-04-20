class PredictPlace{
  String secondary_text;
  String main_text;
  String place_id;
  PredictPlace({this.secondary_text, this.main_text, this.place_id});
  PredictPlace.fromJson(Map<String, dynamic> js){
    place_id = js["place_id"];
    main_text = js["structured_formatting"]["main_text"];
    secondary_text = js["structured_formatting"]["secondary_text"];
  }
}