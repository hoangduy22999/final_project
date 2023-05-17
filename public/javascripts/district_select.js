citySelect = document.getElementById("user_city_id");
districtSelect = document.getElementById("user_district_id");
setDistrictSelect()

function setDistrictSelect() {
  fetch(`http://0.0.0.0:3001/api/v1/districts.json?city_id=${citySelect.value}`)
  .then((response) => response.json())
  .then((data) => {
    var districts = data['data']
    if(districtSelect.length > 2) {
      while (districtSelect[1]) {
        districtSelect[1].remove()
      }
    }
    for(let i = 0; i < districts.length; i++) {
      let district = districts[i]
      if (districtSelect[1] != district['name']) {
        let opt = document.createElement('option');
        opt.value = district['id'];
        opt.innerHTML = district['name'];
        districtSelect.appendChild(opt);
      }
    }
  });
}