ygrep() {
	find . -type f -name '*ym[al]*' -exec grep -Hi $1 {} \;
}
