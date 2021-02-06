"use strict";

import cheerio from "cheerio";
import fetch from "node-fetch";
import fs from "fs";
import phantom from "phantom";

const BASE_URL = "http://www.01xq.com/xqopening";
const OPENINGS_URL = `${BASE_URL}/xqolist.asp`;

async function loadOpeningsPage() {
  const response = await fetch(OPENINGS_URL);
  return response.text();
}

function extractOpenings(html) {
  const $ = cheerio.load(html);
  const openingsTable = $("table#bpwPlayerGame tbody tr");
  let openings = [];
  openingsTable.each((i, e) => {
    const cells = $(e).children("td");
    const code = cells.eq(1).text();
    const link = cells.eq(2).find("a");

    if (code) {
      openings.push({
        code,
        name: link.text().replace(/[^a-zA-Z ]/g, ""),
        link: link.attr("href"),
      });
    }
  });
  return openings;
}

// TODO: Add sample HTML data
function extractMoves($) {
  const movesTable = $("table#movecontent tbody tr");
  let moves = [];
  movesTable.each((i, e) => {
    const link = $(e).children("td").find("a");
    const move = link.text();
    if (move) {
      moves.push(move);
    }
  });
  return moves;
}

function extractGameInfo($) {
  const gameInfoRows = $("div#movetipsdiv tbody tr");
  let gameInfo = {};
  gameInfoRows.each((i, e) => {
    const cells = $(e).children("td");
    if (cells.text().split(":").length > 4) {
      return;
    }

    const key = cells.eq(0).text();
    const value = cells.eq(1).text();

    if (key && value) {
      const cleanKey = key.replace(":", "");
      gameInfo[cleanKey] = value;
    }
  });
  return gameInfo;
}

// function extractPlayerInfo($) {
//   let playerInfo = [];
//   const parent = $("div#DHJHtmlXQ").siblings().eq(1).find("tbody tr td table");
//   console.log(parent.text());

//   parent
//     .last()
//     .find("tbody tr")
//     .eq(1)
//     .children("td")
//     .find("a")
//     .each((i, e) => {
//       const link = $(e).attr("href");
//       const playerName = $(e).find("span").text();
//       if (playerName && link && link.includes("pid")) {
//         const playerID = link.match(/[0-9]+/g)[0];
//         console.log(playerName, playerID);
//         playerInfo.push({ [playerID]: playerName });
//       }
//     });
//   return playerInfo;
// }

function extractLinks($) {
  let gameLinks = [];
  $("table#bpwPlayergame tbody tr").each((i, e) => {
    const gameLink = $(e).children("td").eq(4).find("a").attr("href");

    if (gameLink) {
      gameLinks.push(gameLink);
    }
  });
  return gameLinks;
}

async function* downloadGameData(openings) {
  for (const { link } of openings) {
    const response = await fetch(`${BASE_URL}/${link}`);
    const $ = cheerio.load(await response.text());
    const pagination = $("table#bpwPlayergame").siblings().eq(0);

    const gameLinks = extractLinks($);
    yield { pageNum: 1, gameLinks };

    if (pagination.text()) {
      const matches = pagination.text().match(/\d+/g);
      const numPages = matches[matches.length - 1];

      for (let i = 2; i <= numPages; i++) {
        const response = await fetch(`${BASE_URL}/${link}&page=${i}`);
        const html = await response.text();
        const $ = cheerio.load(html);

        const gameLinks = extractLinks($);
        yield { pageNum: i, gameLinks };
      }
    }
  }
}

async function main() {
  const data = await loadOpeningsPage();
  const openings = extractOpenings(data);
  for await (const { pageNum, gameLinks } of downloadGameData(openings)) {
    for (const gameLink of gameLinks) {
      const instance = await phantom.create();
      const page = await instance.createPage();

      const status = await page.open(gameLink);
      const html = await page.property("content");
      instance.exit();

      const $ = cheerio.load(html);
      const moves = extractMoves($);
      const gameInfo = extractGameInfo($);
      console.log(gameInfo);
      // const playerInfo = extractPlayerInfo($);
      // console.log(playerInfo);
      const idMatches = gameLink.match(/[A-Z0-9]+/gi);
      const id = idMatches[idMatches.length - 1];

      await fs.promises.writeFile(
        `./data/game-${id}.json`,
        JSON.stringify({ ...gameInfo, moves })
        // JSON.stringify({ ...gameInfo, ...playerInfo, moves })
      );
    }
  }

  fs.writeFileSync("./data/openings.json", JSON.stringify(openings));
}

if (require.main === module) {
  main();
}
