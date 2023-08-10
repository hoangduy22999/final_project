import { notification } from "antd";
import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("NotificationChannel connected")
  },

  disconnected() {
    console.log("NotificationChannel disconnected")
  },

  received(data) {
    addNewNotificationInList(data)
    console.log(`${data["incoming_notification"] + data["user_name"]}`)
    toastr.success(data["incoming_notification"], data["user_name"])

    Notification.requestPermission().then(permission => {
      const notification = new Notification("Notification",
      {
        body: data["incoming_notification"]
      })
    })
  }
});



function addNewNotificationInList(data){
  document.getElementById("headerNotificationCount").innerHTML = data["count"];
  var listNotificationInHeader = document.getElementById("listNotificationInHeader");
  if (listNotificationInHeader.childElementCount >= 3) {
    listNotificationInHeader.removeChild(listNotificationInHeader.lastElementChild);
  }
  listNotificationInHeader.insertAdjacentHTML('beforebegin', notificationInList(data));
}

function notificationInList(data) {
  return `<a class="dropdown-item d-flex align-items-center" href="${data["href"]}">
      <div class="mr-3">
          <div class="icon-circle bg-success">
              <i class="fas fa-code-pull-request"></i>
          </div>
      </div>
      <div>
          <div class="small text-gray-500">${data["sended_at"]}</div>
            <span class="font-weight-bold">
              ${data["incoming_notification"]}
            </span>
      </div>
  </a>`
}