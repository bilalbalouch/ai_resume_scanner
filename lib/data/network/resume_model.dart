/// job_description : "Need flutter developer with experiace in firabase and restapi"
/// ranked_resumes : [{"candidate_name":"Bilal","email":"bilaltechworld@gmail.com","rank":1,"resume_file":"Bilal (2).pdf","resume_url":"http://79577e3a4858.ngrok-free.app/resumes/Bilal (2).pdf","score":64.74,"skills":["Firebase","Software Engineering","Rest Api","Flutter","Android","Dart","Java"]},{"candidate_name":"Noman","email":"shahzadnadeem@gmail.com","rank":2,"resume_file":"Noman.pdf","resume_url":"http://79577e3a4858.ngrok-free.app/resumes/Noman.pdf","score":61.7,"skills":["Software Engineering","Rest Api","Flutter","Android","Dart","Sql"]},{"candidate_name":"Nadeem","email":"bilaltechworld@gmail.com","rank":3,"resume_file":"Nadeem.pdf","resume_url":"http://79577e3a4858.ngrok-free.app/resumes/Nadeem.pdf","score":59.48,"skills":["Software Engineering","Android","Rest Api","Flutter","Dart"]},{"candidate_name":"Sayed Ali","email":"ali@gmail.com","rank":4,"resume_file":"Sayed Ali.pdf","resume_url":"http://79577e3a4858.ngrok-free.app/resumes/Sayed Ali.pdf","score":40.84,"skills":["Rest Api","Android","Java"]},{"candidate_name":"Usman Bari","email":"usman@gmail.com","rank":5,"resume_file":"Usman Bari.pdf","resume_url":"http://79577e3a4858.ngrok-free.app/resumes/Usman Bari.pdf","score":19.55,"skills":["Javascript","Web Development","Css","Java","Html"]}]
/// total_resumes : 5

class ResumeModel {
  ResumeModel({
      String? jobDescription, 
      List<RankedResumes>? rankedResumes, 
      num? totalResumes,}){
    _jobDescription = jobDescription;
    _rankedResumes = rankedResumes;
    _totalResumes = totalResumes;
}

  ResumeModel.fromJson(dynamic json) {
    _jobDescription = json['job_description'];
    if (json['ranked_resumes'] != null) {
      _rankedResumes = [];
      json['ranked_resumes'].forEach((v) {
        _rankedResumes?.add(RankedResumes.fromJson(v));
      });
    }
    _totalResumes = json['total_resumes'];
  }
  String? _jobDescription;
  List<RankedResumes>? _rankedResumes;
  num? _totalResumes;
ResumeModel copyWith({  String? jobDescription,
  List<RankedResumes>? rankedResumes,
  num? totalResumes,
}) => ResumeModel(  jobDescription: jobDescription ?? _jobDescription,
  rankedResumes: rankedResumes ?? _rankedResumes,
  totalResumes: totalResumes ?? _totalResumes,
);
  String? get jobDescription => _jobDescription;
  List<RankedResumes>? get rankedResumes => _rankedResumes;
  num? get totalResumes => _totalResumes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['job_description'] = _jobDescription;
    if (_rankedResumes != null) {
      map['ranked_resumes'] = _rankedResumes?.map((v) => v.toJson()).toList();
    }
    map['total_resumes'] = _totalResumes;
    return map;
  }

}

/// candidate_name : "Bilal"
/// email : "bilaltechworld@gmail.com"
/// rank : 1
/// resume_file : "Bilal (2).pdf"
/// resume_url : "http://79577e3a4858.ngrok-free.app/resumes/Bilal (2).pdf"
/// score : 64.74
/// skills : ["Firebase","Software Engineering","Rest Api","Flutter","Android","Dart","Java"]

class RankedResumes {
  RankedResumes({
      String? candidateName, 
      String? email, 
      num? rank, 
      String? resumeFile, 
      String? resumeUrl, 
      num? score, 
      List<String>? skills,}){
    _candidateName = candidateName;
    _email = email;
    _rank = rank;
    _resumeFile = resumeFile;
    _resumeUrl = resumeUrl;
    _score = score;
    _skills = skills;
}

  RankedResumes.fromJson(dynamic json) {
    _candidateName = json['candidate_name'];
    _email = json['email'];
    _rank = json['rank'];
    _resumeFile = json['resume_file'];
    _resumeUrl = json['resume_url'];
    _score = json['score'];
    _skills = json['skills'] != null ? json['skills'].cast<String>() : [];
  }
  String? _candidateName;
  String? _email;
  num? _rank;
  String? _resumeFile;
  String? _resumeUrl;
  num? _score;
  List<String>? _skills;
RankedResumes copyWith({  String? candidateName,
  String? email,
  num? rank,
  String? resumeFile,
  String? resumeUrl,
  num? score,
  List<String>? skills,
}) => RankedResumes(  candidateName: candidateName ?? _candidateName,
  email: email ?? _email,
  rank: rank ?? _rank,
  resumeFile: resumeFile ?? _resumeFile,
  resumeUrl: resumeUrl ?? _resumeUrl,
  score: score ?? _score,
  skills: skills ?? _skills,
);
  String? get candidateName => _candidateName;
  String? get email => _email;
  num? get rank => _rank;
  String? get resumeFile => _resumeFile;
  String? get resumeUrl => _resumeUrl;
  num? get score => _score;
  List<String>? get skills => _skills;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['candidate_name'] = _candidateName;
    map['email'] = _email;
    map['rank'] = _rank;
    map['resume_file'] = _resumeFile;
    map['resume_url'] = _resumeUrl;
    map['score'] = _score;
    map['skills'] = _skills;
    return map;
  }

}