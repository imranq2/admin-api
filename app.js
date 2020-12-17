'use strict';

const express = require('express');
const {exec} = require("child_process");

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
    res.send('Hello World');
});

app.get('/copy', async (req, res) => {
    exec("ls -la", (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    });
    res.status(200).json({success: true, result: stdout});
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
