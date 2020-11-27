const fs = require('fs')
const WebSocket = require('ws');
const { SSHConnection } = require('node-ssh-forward');
const Clipboard = require('./clipboard');

const sshConnection = new SSHConnection({
  endHost: process.env.DEVICE_IP,
  password: process.env.SSH_PASSWORD,
  privateKey: process.env.SSH_PRIVATEKEY ? fs.readFileSync(process.env.SSH_PRIVATEKEY) : undefined,
  passphrase: process.env.SSH_PRIVATEKEY_PASSPHRASE,
})

// clipboard
const clipboard = new Clipboard();

let ws = undefined;
let currentClip;

clipboard.on('ready', async () => {
  await sshConnection.forward({
    fromPort: 6969,
    toPort: 6969,
  });

  ws = new WebSocket(`ws://localhost:${6969}`);

  ws.on('open', () => {
    console.log('connected');
  });
  ws.on('close', () => process.exit());

  ws.on('message', (data) => {
    if (currentClip === data) return;
    console.log('received:', data);
    clipboard.write(data);
    currentClip = data;
  });

  console.log('clipboard started');
})

clipboard.on('change', (data) => {
  if (currentClip === data) return;
  console.log('clipboard changed!', data);
  currentClip = data;
  if (ws) ws.send(data);
})

clipboard.start();
