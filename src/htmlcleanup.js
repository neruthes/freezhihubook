const { JSDOM } = require('jsdom');
const fs = require('fs');

const input_html = fs.readFileSync(process.argv[2]).toString();

function removeUnwantedElements(htmlString) {
    const dom = new JSDOM(htmlString);
    ['svg', 'img'].forEach(function (tag) {
        const unwantedElements = dom.window.document.querySelectorAll(tag);
        // Remove all unwanted elements
        unwantedElements.forEach(element => {
            element.parentNode.removeChild(element);
        });
    });

    return dom.serialize();
}

// Example usage
const htmlString = input_html;

console.log(removeUnwantedElements(htmlString));
