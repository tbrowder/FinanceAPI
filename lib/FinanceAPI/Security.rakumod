unit class FinanceAPI::Security;

has $.symbol is required;

has %.dailys; # keys are Dates
