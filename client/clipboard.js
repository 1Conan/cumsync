const { EventEmitter } = require('events');
const clipboardy = require('clipboardy');

module.exports = class extends EventEmitter {
  lastClipboardItem = undefined;

  constructor() {
    super();
  }

  async start() {
    this.lastClipboardItem = await this.read();
    this.interval = setInterval(() => this.poller(), 500);
    this.emit('ready');
  }

  stop() {
    clearInterval(this.interval);
  }

  write(data) {
    return clipboardy.write(data);
  }

  read() {
    return clipboardy.read();
  }

  async poller() {
    const current = await clipboardy.read();
    if (current === this.lastClipboardItem) return;
    if (current.trim().length < 1) return;

    this.emit('change', current);
    this.lastClipboardItem = current;
  }
}