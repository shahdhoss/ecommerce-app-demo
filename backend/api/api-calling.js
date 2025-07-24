const fs = require("fs")
const category_id = 281610
const url = `https://real-time-amazon-data.p.rapidapi.com/products-by-category?category_id=${category_id}&page=1&country=US&sort_by=RELEVANCE&product_condition=ALL`;
const options = {
	method: 'GET',
	headers: {
		'x-rapidapi-key': '90d92653e3msh1bf7fe079c16084p1cc8aejsn307490a88df2',
		'x-rapidapi-host': 'real-time-amazon-data.p.rapidapi.com'
	}
};

async function fetchData() {
	try {
		const response = await fetch(url, options);
		const result = await response.json()
		console.log(result.data.products)
		const products = result["data"]["products"]
		fs.writeFile(`${category_id}.json`, JSON.stringify(products, null, 2), (err) => {
			if (err) {
				console.error('Error writing to file:', err);
			} else {
				console.log('Products saved to products.json');
			}
		});
	} catch (error) {
		console.error(error);
	}
}

fetchData(); 
