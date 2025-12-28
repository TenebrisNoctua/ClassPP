<script>
    const targetURL = "https://tenebrisnoctua.github.io/ClassPP/2.0/api-reference/general/errors/"
    const currentFragment = window.location.hash;
    if (currentFragment) {
        const newURL = targetURL + currentFragment;
        window.location.href = newURL;
    } else {
        window.location.href = targetURL;
    }
</script>