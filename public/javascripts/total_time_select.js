function setTotalHour(){
  startTime = Date.parse(document.getElementById("leave_request_start_date").value);
  endTime = Date.parse(document.getElementById("leave_request_end_date").value);
  var totalHour = 0;

  if (startTime && endTime && startTime <= endTime) {
    let totalInputHours = (endTime - startTime)/1000/60/60;
    let totalDays = parseInt(totalInputHours / 24);
    totalHour = totalDays * 8;
  }

  document.getElementById("leave_request_total_hours").value = totalHour;
}