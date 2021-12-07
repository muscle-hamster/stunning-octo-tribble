import axios from 'axios'
import fs from 'fs/promises'

export const callRemoteVcs = (organization, repository, headCommit, baseCommit) => {
  try {
    return axios.get(`https://api.github.com/repos/${organization}/${repository}/compare/${headCommit}...${baseCommit}`)
  } catch(err) {
    throw err
  }
}

export const parseCommitData = (data) => {
  return data.commits.map((commit) => {
    return {
      "author": `${commit.commit.author.name}`,
      "url": `${commit.commit.author.url}`,
      "date": `${commit.commit.author.date}`,
      "message": `${commit.commit.message}`
    }
  })
}

export const writeDataToFile = async (content) => {
  try {
    await fs.writeFile('output.json', content)
  } catch (err) {
    throw err
  }
}

export const collectArgs = (extraDataLength) => {
   return process.argv.slice(extraDataLength);
}

