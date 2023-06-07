import { Controller } from 'stimulus'; 
export default class extends Controller {
  static targets = ['messageId'];
  
  connect() {
    console.log("hello from StimulusJS")
  }

  greet() {
    console.log("hello from StimulusJS")
  }
}