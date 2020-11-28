const fs = require('fs')
const WebSocket = require('ws');
const { SSHConnection } = require('node-ssh-forward');
const getPort = require('get-port');
const Clipboard = require('./clipboard');

let ws = undefined;
let currentClip;

// clipboard
const clipboard = new Clipboard();

clipboard.on('ready', async () => {
  console.log('clipboard started');
})

clipboard.on('change', (data) => {
  if (currentClip === data) return;
  console.log('clipboard changed!', data.trim());
  currentClip = data;
  if (ws && ws.readyState === 1) ws.send(data);
})

const sshConnection = new SSHConnection({
  endHost: process.env.DEVICE_IP,
  password: process.env.SSH_PASSWORD,
  privateKey: process.env.SSH_PRIVATEKEY ? fs.readFileSync(process.env.SSH_PRIVATEKEY) : undefined,
  passphrase: process.env.SSH_PRIVATEKEY_PASSPHRASE,
  skipAutoPrivateKey: !!process.env.SSH_SKIP_PRIVATEKEY,
})

async function main() {
  const port = await getPort();
  await sshConnection.forward({
    fromPort: port,
    toPort: 6969,
  });
  ws = new WebSocket(`ws://localhost:${port}`);

  ws.on('open', () => console.log(`connected to ${process.env.DEVICE_IP}`));
  ws.on('close', () => process.exit());
  ws.on('message', (data) => {
    if (currentClip === data) return;
    console.log('received:', data.trim());
    clipboard.write(data);
    currentClip = data;
  });

  clipboard.start();
}
main();
