# vitess-resources

External resources for Vitess builds and tests.

This repo exists as a 3rd party and otherwise large external resources used for building open source [Vitess](https://github.com/vitessio/vitess).

We wish to reduce the 3rd party/external dependencies in the Vitess build process. Pulling artifacts from multiple external vendors is risky, since any of them can go offline, or can remove artifacts from their download pages, or can change URLs without warning.

Instead, we are incorporating these artifacts in _this_ repo. Since Vitess already depends on GitHub to build (hosted on GitHub, CI uses GitHub Actions), there is little increased risk. Moreover, we now pin down artifacts and can ensure they're never going away.

Artifacts are uploaded as part of a `release`. For example, at this time we have:

 * `v3.0`: https://github.com/vitessio/vitess-resources/releases/tag/v3.0
 * `v2.0`: https://github.com/vitessio/vitess-resources/releases/tag/v2.0
 * `v1.0`: https://github.com/vitessio/vitess-resources/releases/tag/v1.0
