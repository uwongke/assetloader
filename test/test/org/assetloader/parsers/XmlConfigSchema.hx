package test.org.assetloader.parsers;

typedef XmlConfigSchema = {
    loader: {
        _attributes: {
            connections: Int,
            base: String
        },
        group: {
            _attributes: {
                id: String,
                connections: String,
                preventCache: String
            },
            group: {
                _attributes: {
                    id: String,
                    connections: String
                },
                asset: Array<{
                    _attributes: {
                        id: String,
                        src: String
                    }
                }>,
            },
            asset: Array<{
                _attributes: String,
                src: String,
                weight: String
            }>,
        },
        assets: {
            _attributes: {
                preventCache: Bool
            },
            asset: Array<{
                _attributes: {
                    id: String,
                    src: String,
                    weight: String,
                    smoothing: Bool,
                    transparent: Bool,
                    onDemand: Bool,
                    priority: Int
                }
            }>,
        },
        asset: {
            _attributes: {
                id: String,
                base: String,
                src: String,
                type: String,
                retries: String
            }
        }
    }
}
