citySelect = document.getElementById("user_city_id");
districtSelect = document.getElementById("user_district_id");
setDistrictSelect()

user_avatar.onchange = function (){
  const [file] = this.files
  if (file) {
    var currentAvatar = document.getElementById("formAvatar")
    if (currentAvatar){
      currentAvatar.src = URL.createObjectURL(file)
    }
    else {
      var newAvatar = document.createElement('image');
      newAvatar.src = URL.createObjectURL(file)
      console.log(newAvatar)
      document.getElementById("avatarDiv").appendChild(newAvatar)
    }
  }
}

function setDistrictSelect() {
  fetch(`http://127.0.0.1:3001/api/v1/districts.json?city_id=${citySelect.value}`)
  .then((response) => response.json())
  .then((data) => {
    var districts = data['data']
    if(districtSelect.length > 2) {
      while (districtSelect[1]) {
        districtSelect[1].remove()
      }
    }
    for(let i = 0; i < districts.length; i++) {
      let district = districts[i]['attributes']
      if (districtSelect[1] != district['name']) {
        let opt = document.createElement('option');
        opt.value = district['id'];
        opt.innerHTML = district['name'];
        districtSelect.appendChild(opt);
      }
    }
  });
}