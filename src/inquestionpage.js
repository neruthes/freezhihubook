// Run this script in web console
(function () {
    const list = [].filter.call(document.querySelectorAll('a'), function (node) {
        return node.getAttribute('href').match(/\/question\/\d+\/answer\/\w+/g);
    }).map(function (node) {
        return node.href;
    }).filter(href => href.startsWith('https://freezhihu.org')).join('\n');
    let output = `URL_LIST="${list}" ./make.sh wgetall 2023`; // Remember to change year!
    copy(output);
    console.log(output);
})()
