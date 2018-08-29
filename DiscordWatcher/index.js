// jshint esversion: 6
/*
Author: Emi Bemol <esauvisky@gmail.com>
*/

// Libraries
const Discord = require('discord.js');
const colors = require('colors');
const fs = require("fs");
var spawn = require('child_process').spawn;

// Grabs configs from the JSON file
const config = require('./config.json');


// Here we define our client, most people call it "client" but I prefer to call it "bot".
bot = new Discord.Client({forceFetchUsers: true});

// When our bot is ready.
bot.on("ready", () =>{
    // We will send a message to our console telling us that the bot has initiated correctly.
    console.log('The bot is online!'.green);
});

// When a message is received, run the following code.
//bot.on("message", async (message) => {
bot.on("message", (message) => {
    let msg = String(message.content).toLowerCase();
    let channelId = String(message.channel).substring(2, String(message.channel).length - 1);
    let channelName = bot.channels.find("id", channelId).name;

    let keyword = config.keywords.find(keyword => msg.includes(keyword));


    // Bail out if the channel is not being watched
    if (! config.watchingChannels.includes(channelName)) { return; }

    // Prints all messages
    if (config.debugMode) { console.log(colors.grey(msg + ' (' + channelId + ':' + channelName + ')')); }

    // TODO: get every message from channels 2000, 2600 cp and #level30community
    // TODO: remove citations (emojis, mentions, links and so on), like <@12345> :flag_nz: and so on

    if(keyword) {
        console.log(colors.bold.yellow('#' + channelName + '' + keyword.toUpperCase()));
        console.log(message.content + '\n');
        spawn('notify-send', [channelName + " (" + keyword.toUpperCase() + ")", message.content]);
    // } else if (msg.indexOf('37.') >= 1 && msg.indexOf('-122.') >= 1) {
    } else {
        config.niceCoords.forEach(function(coordPair) {
            if (msg.indexOf(coordPair[0]) >= 0 && msg.indexOf(coordPair[1]) >= 0) {
                console.log(colors.bold.green(channelName + ' ('+ coordPair[2] +')'));
                console.log(msg + '\n');
                spawn('notify-send', [channelName + " (Coordinate)", msg]);
            }
        });
    }
});

function sleep (time) {
    return new Promise((resolve) => setTimeout(resolve, time));
}


/**********************************
********** Weird Stuff! ***********
**********************************/
// Suppreses Undhandled Promise Rejections
process.on("unhandledRejection", (reason, p) => {
    if (config.debugMode) {
        console.log(colors.red.bold("Discord's unhandled Rejection:"));
        console.log(colors.red("- Reason:\t" + `${reason}`));
        console.log(colors.red("- Promise:\t" + `${require("util").inspect(p, {depth: 3})}`));
    }
});
// This tests the suppresion below
//new Promise((_, reject) => reject({ test: 'woops!' }));

// Logs warnings and errors
process.on("warning", (warning) => {
    console.log(colors.red.bold("A warning ocurred!"));
    console.log(colors.red(warning.name));
    console.log(colors.red(warning.message));
    console.log(colors.red(warning.stack));
});
process.on("error", (error) => {
    console.log(colors.red.bold("An error ocurred!"));
    console.log(colors.red(error.name));
    console.log(colors.red(error.message));
    console.log(colors.red(error.stack));
});
bot.login(config.token); // Login as our bot using the token specified in config.json.