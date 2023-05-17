function setupImage([file]){
  if (file) {
    console.log(file)
    var currentImage = document.getElementById("formImage")
    if (currentImage){
      currentImage.src = URL.createObjectURL(file)
    }
    else {
      var newImage = document.createElement('image');
      newImage.src = URL.createObjectURL(file)
      document.getElementById("imageDiv").appendChild(newImage)
    }
  }
}