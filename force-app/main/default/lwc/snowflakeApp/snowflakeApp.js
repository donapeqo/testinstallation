import { LightningElement, track } from 'lwc';

export default class SnowflakeApp extends LightningElement {
    @track flake;

  handleKeyUp(event) {
    this.flake = event.target.value;
  }

  renderedCallback() {
    this.template.querySelector('input').addEventListener('keyup', this.handleKeyUp.bind(this));
  }
}