const { collectArgs, parseCommitData, callRemoteVcs } = require('../src/utils')

test('Successfully gets command line args', () => {
  const args = collectArgs(3)
  expect(args).toHaveLength(4)
})

test('Commit data structure is correct', async () => {
  try {
    const { data: remoteData } = await callRemoteVcs(`hashicorp`, `terraform`, `v1.1.0-rc1`, `v1.0.11`)
    const parsedData = parseCommitData(remoteData)
    expect(parsedData).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          author: expect.any(String),
          date: expect.any(String),
          message: expect.any(String),
          url: expect.anything()
        })
      ])
    )
  } catch(err) {
    throw err
  }
})
