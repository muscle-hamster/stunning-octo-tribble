import { callRemoteVcs, parseCommitData, writeDataToFile, collectArgs } from 'utils'

(async () => {
  try {
    const args = collectArgs(2)
    const { data: remoteData } = await callRemoteVcs(`${args[0]}`, `${args[1]}`, `${args[2]}`, `${args[3]}`)
    const parsedData = parseCommitData(remoteData)
    writeDataToFile(JSON.stringify(parsedData))
  } catch(err) {
    throw err
  }
})();
