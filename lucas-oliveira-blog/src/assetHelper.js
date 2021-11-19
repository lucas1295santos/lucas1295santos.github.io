export default function postPath(path) {
  return process.env.PUBLIC_URL + '/content/' + path + '/' + path + '.html'
}
