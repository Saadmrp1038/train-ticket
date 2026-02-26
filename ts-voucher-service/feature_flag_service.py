from openfeature import api
from openfeature.contrib.provider.flagd import FlagdProvider
from openfeature.contrib.provider.flagd.config import ResolverType, CacheType


class FeatureFlagService:
    def __init__(self) -> None:
        provider = FlagdProvider(
            resolver_type=ResolverType.RPC,
            host="flagd",
            port=8013,
            cache=CacheType.DISABLED,
            max_cache_size=0,
        )
        api.set_provider(provider)
        self.client = api.get_client("voucher-service")

    def is_enabled(self, flag_name: str) -> bool:
        try:
            details = self.client.get_boolean_details(flag_name, False)

            if getattr(details, "reason", None) == "ERROR":
                return False
            return bool(details.value)
        except Exception:
            return False
